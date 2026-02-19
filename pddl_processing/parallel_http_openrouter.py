"""
Parallel HTTP requests to OpenRouter (or any OpenAI-compatible chat completions API)
to speed up domain translation (many predicates/actions in parallel).
"""
import json
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import List, Optional


def _single_request(
    api_url: str,
    api_key: str,
    model: str,
    messages: List[dict],
    temperature: float,
    max_tokens: int,
    seed: Optional[int],
    timeout: int,
) -> str:
    """Send one chat completion request; return content or empty string on error."""
    url = api_url.rstrip("/") + "/chat/completions" if "/chat/completions" not in api_url else api_url
    body = {
        "model": model,
        "messages": messages,
        "temperature": temperature,
        "max_tokens": max_tokens,
    }
    if seed is not None:
        body["seed"] = seed

    req = urllib.request.Request(
        url,
        data=json.dumps(body).encode("utf-8"),
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {api_key}",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            data = json.loads(resp.read().decode("utf-8"))
    except (urllib.error.URLError, urllib.error.HTTPError, json.JSONDecodeError, KeyError) as e:
        return ""
    choices = data.get("choices") or []
    if not choices:
        return ""
    msg = choices[0].get("message") or {}
    content = msg.get("content")
    return content if isinstance(content, str) else ""


def parallel_chat_completions(
    api_url: str,
    api_key: str,
    model: str,
    base_messages: List[dict],
    user_messages: List[str],
    max_workers: int = 8,
    temperature: float = 0.0,
    max_tokens: int = 1024,
    seed: Optional[int] = None,
    timeout: int = 120,
) -> List[str]:
    """
    Send multiple chat completion requests in parallel (same base prompt, different user message each).
    :param api_url: e.g. https://openrouter.ai/api/v1
    :param api_key: Bearer token
    :param model: model id
    :param base_messages: list of {"role": "system"|"user"|"assistant", "content": "..."} (no final user message)
    :param user_messages: list of final user messages (one per request)
    :param max_workers: max concurrent requests
    :return: list of response contents (same order as user_messages); "" on error
    """
    def task(i: int, user_msg: str) -> tuple:
        messages = base_messages + [{"role": "user", "content": user_msg}]
        content = _single_request(
            api_url=api_url,
            api_key=api_key,
            model=model,
            messages=messages,
            temperature=temperature,
            max_tokens=max_tokens,
            seed=seed,
            timeout=timeout,
        )
        return (i, content)

    results = [""] * len(user_messages)
    with ThreadPoolExecutor(max_workers=max_workers) as ex:
        futures = {ex.submit(task, i, msg): i for i, msg in enumerate(user_messages)}
        for fut in as_completed(futures):
            try:
                i, content = fut.result()
                results[i] = content or ""
            except Exception:
                pass
    return results
