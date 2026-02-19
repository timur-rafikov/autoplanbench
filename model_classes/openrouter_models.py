"""
OpenRouter API via official SDK (https://openrouter.ai/docs/sdks/python).
Install: pip install openrouter
"""
from concurrent.futures import ThreadPoolExecutor, TimeoutError as FuturesTimeoutError
from typing import List, Union

from model_classes.llm_models import LLMModel

# Request timeout (seconds); SDK has no built-in timeout, so we enforce it here
OPENROUTER_REQUEST_TIMEOUT = 120


class OpenRouterChatModel(LLMModel):
    """Chat model using the OpenRouter Python SDK instead of the OpenAI client."""

    def __init__(
        self,
        model_name: str,
        model_path: str,
        max_tokens: int,
        temp: float,
        max_history: Union[int, None],
        cache_directory: Union[str, None] = None,
        seed: Union[int, None] = None,
        api_key: Union[None, str] = None,
        http_referer: Union[None, str] = "http://localhost",
    ):
        super().__init__(
            model_name=model_name,
            model_path=model_path,
            max_tokens=max_tokens,
            temp=temp,
            max_history=max_history,
            cache_directory=cache_directory,
            seed=seed,
        )
        self.api_key = api_key or ""
        self.http_referer = http_referer
        self._sdk_client = None

    def _get_client(self):
        """Lazy init of OpenRouter SDK client (context manager used per request)."""
        from openrouter import OpenRouter

        return OpenRouter(
            api_key=self.api_key,
            http_referer=self.http_referer or "",
        )

    def init_model(self, init_prompt: str):
        self.initial_prompt = init_prompt
        if not init_prompt:
            self.initial_history = []
        else:
            self.history.append({"role": "system", "content": self.initial_prompt})
            self.full_history_w_source.append({
                "role": "system",
                "content": self.initial_prompt,
                "source": "initial_input",
            })
            self.initial_history = [{"role": "system", "content": self.initial_prompt}]
        self.role_user = "user"
        self.role_assistant = "assistant"

    def add_examples(self, examples: List[dict]) -> None:
        for example in examples:
            role_type = example["role"]
            role = self.role_user if role_type == "user" else self.role_assistant
            if role_type not in ("user", "assistant"):
                raise ValueError
            content = example["content"]
            self.history.append({"role": role, "content": content})
            self.full_history_w_source.append({
                "role": role,
                "content": content,
                "source": "initial_input",
            })
        self.initial_history = self.history.copy()

    def _generate(self, prompt: str):
        short = (prompt[:60] + "…") if len(prompt) > 60 else prompt
        print(f"[OpenRouter] Sending request (model={self.model_path}): {short!r}")

        def _do_call():
            kwargs = {
                "messages": self.history,
                "model": self.model_path,
                "stream": False,
                "temperature": self.temp,
                "max_tokens": self.max_tokens,
            }
            if self.seed is not None:
                kwargs["seed"] = self.seed
            with self._get_client() as client:
                res = client.chat.send(**kwargs)
            return self._sdk_response_to_dict(res)

        try:
            with ThreadPoolExecutor(max_workers=1) as ex:
                future = ex.submit(_do_call)
                return future.result(timeout=OPENROUTER_REQUEST_TIMEOUT)
        except FuturesTimeoutError:
            print(f"OpenRouter request timed out ({OPENROUTER_REQUEST_TIMEOUT}s). Use a valid model id, e.g. openai/gpt-3.5-turbo (https://openrouter.ai/models).")
            return self._empty_response()
        except Exception as e:
            err_msg = str(e)
            if "Internal Server Error" in err_msg or "ChatError" in type(e).__name__:
                print(f"OpenRouter API error: {e}")
                print("Tip: Use a valid model id, e.g. openai/gpt-3.5-turbo or openai/gpt-4o-mini (see https://openrouter.ai/models).")
            return self._empty_response()

    def _empty_response(self) -> dict:
        """Return a response dict with empty content (for API errors so fallback template is used)."""
        return {
            "choices": [{"message": {"content": "", "role": "assistant"}, "finish_reason": "stop", "index": 0}],
            "usage": {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0},
        }

    def _sdk_response_to_dict(self, res) -> dict:
        """Convert OpenRouter SDK response to our standard dict (choices[0].message.content + usage)."""
        out = {
            "choices": [{"message": {"content": None, "role": "assistant"}, "finish_reason": "stop", "index": 0}],
            "usage": {"prompt_tokens": 0, "completion_tokens": 0, "total_tokens": 0},
        }
        content = None
        usage = None

        def extract_content_and_usage(obj):
            c, u = None, None
            if hasattr(obj, "choices") and obj.choices:
                c0 = obj.choices[0]
                msg = getattr(c0, "message", c0) if hasattr(c0, "message") else c0
                c = getattr(msg, "content", None) if hasattr(msg, "content") else (msg.get("content") if isinstance(msg, dict) else None)
                if c is None and isinstance(c0, dict):
                    c = (c0.get("message") or {}).get("content")
            if hasattr(obj, "usage"):
                u = obj.usage
            if hasattr(obj, "content"):
                c = obj.content
            if isinstance(obj, dict):
                c = c or obj.get("content") or (obj.get("choices") or [{}])[0].get("message", {}).get("content")
                u = u or obj.get("usage")
            return c, u

        try:
            # stream=False: res may be a single object with .choices / .content
            content, usage = extract_content_and_usage(res)
            if content is None and usage is None:
                # SDK: "with res as event_stream: for event in event_stream"
                with res as event_stream:
                    for event in event_stream:
                        content, usage = extract_content_and_usage(event)
                        if content is not None or usage is not None:
                            break
        except Exception:
            pass

        if content is None:
            content = ""
        out["choices"][0]["message"]["content"] = content
        if usage is not None:
            if hasattr(usage, "prompt_tokens"):
                out["usage"] = {
                    "prompt_tokens": getattr(usage, "prompt_tokens", 0),
                    "completion_tokens": getattr(usage, "completion_tokens", 0),
                    "total_tokens": getattr(usage, "total_tokens", 0),
                }
            elif isinstance(usage, dict):
                out["usage"] = {
                    "prompt_tokens": usage.get("prompt_tokens", 0),
                    "completion_tokens": usage.get("completion_tokens", 0),
                    "total_tokens": usage.get("total_tokens", 0),
                }
        return out

    def update_token_counts(self, usage_dict: dict):
        self.total_input_tokens += usage_dict.get("prompt_tokens", 0)
        self.total_output_tokens += usage_dict.get("completion_tokens", 0)
        self.total_tokens += usage_dict.get("total_tokens", 0)
        pt = usage_dict.get("prompt_tokens", 0)
        ct = usage_dict.get("completion_tokens", 0)
        tt = usage_dict.get("total_tokens", 0)
        if pt > self.max_input_tokens:
            self.max_input_tokens = pt
        if ct > self.max_output_tokens:
            self.max_output_tokens = ct
        if tt > self.max_total_tokens:
            self.max_total_tokens = tt

    def _is_response_empty(self, response) -> bool:
        if not response or not isinstance(response, dict):
            return True
        content = response.get("choices", [{}])[0].get("message", {}).get("content")
        return content is None or (isinstance(content, str) and not content.strip())

    def create_cache_query(self, prompt: str):
        text_query = ""
        for entry in self.history:
            for role, content in entry.items():
                text_query += f"{role}: {content} // "
        return (text_query, self.seed)

    def prepare_for_generation(self, user_message) -> str:
        self.history.append({"role": self.role_user, "content": user_message})
        self.full_history_w_source.append({
            "role": self.role_user,
            "content": user_message,
            "source": "user",
        })
        return user_message

    def clean_up_from_generation(self, model_response: dict, response_source: Union[str, None] = None) -> str:
        choices = model_response.get("choices") or []
        first = choices[0] if choices else {}
        message = first.get("message") or {}
        text_output = message.get("content")
        if text_output is None:
            text_output = ""

        self.history.append({"role": self.role_assistant, "content": text_output})
        self.full_history_w_source.append({
            "role": self.role_assistant,
            "content": text_output,
            "source": response_source,
        })

        if "usage" in model_response:
            self.update_token_counts(model_response["usage"])

        return text_output
