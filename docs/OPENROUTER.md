# Использование OpenRouter вместо OpenAI

---

## Как запустить перевод (PDDL ↔ NL)

### 1. Перевод PDDL → естественный язык (описания домена)

Генерация текстовых описаний предикатов и действий из `domain.pddl` с помощью LLM:

```bash
# Из корня проекта (d:\work\autoplanbench или где установлен пакет)
# Задайте ключ API (OpenAI или OpenRouter):
set OPENAI_API_KEY=sk-...

python run_domain_setup.py -o ./data/имя_домена --llm gpt-4o --seed 0
```

- **`-o`** — каталог с данными домена: в нём должны быть `domain.pddl` и подкаталог `orig_problems/` с исходными задачами (`.pddl`).
- **`--llm`** — имя модели (для OpenAI: `gpt-4o`, `gpt-4` и т.д.; для OpenRouter см. ниже).
- **`--seed`** — seed для воспроизводимости.
- Опционально: **`-n`** — число инстансов, **`--len`** — ограничение длины плана, **`--overwrite`** — перезаписать существующие файлы.

В результате в каталоге `-o` появятся:
- `*_description_seed{seed}.json` — описания домена на естественном языке;
- `translation_examples_seed{seed}.json` — примеры для перевода NL→PDDL (few-shot);
- адаптированные инстансы и золотые планы (если не указано `-n 0`).

**Для OpenRouter** (перевод PDDL→NL через OpenRouter):

```bash
set OPENROUTER_API_KEY=sk-or-v1-...
python run_domain_setup.py -o ./data/имя_домена --llm openai/gpt-4o --seed 0 --base-url https://openrouter.ai/api/v1 --api-key %OPENROUTER_API_KEY%
```

(В PowerShell: `$env:OPENROUTER_API_KEY="sk-or-v1-..."; ... --api-key $env:OPENROUTER_API_KEY`.)

### 2. Перевод NL → PDDL (во время планирования)

Перевод шагов с естественного языка в PDDL выполняется **внутри запуска планирования**: планирующая модель выдаёт инструкции на NL, модель перевода переводит их в PDDL. Отдельного скрипта «только перевод» нет.

Запуск планирования с конфигом (в т.ч. с OpenRouter):

```bash
python run_planning.py -c configs/имя_домена_seed0_configs/config_react_имя_домена_seed0.json
```

Конфиг должен содержать блоки `plan` и `translate` с нужными `model_path`, `base_url`, `api_key` (см. ниже и `configs/templates/react_template_config_openrouter.json`).

---

# Использование OpenRouter вместо OpenAI (продолжение)

OpenRouter предоставляет единый API к разным LLM (OpenAI, Anthropic, Google и др.) и **совместим с OpenAI SDK**: тот же интерфейс `chat.completions.create()`. Библиотека autoplanbench поддерживает OpenRouter без смены кода — достаточно изменить конфигурацию.

## Что сделано в коде

- В **`model_classes/openai_models.py`** у `OpenAIChatModel` добавлен опциональный параметр **`base_url`**. Если он задан, клиент создаётся с `OpenAI(api_key=..., base_url=...)`.
- Константа **`OPENROUTER_BASE_URL = "https://openrouter.ai/api/v1"`** экспортируется из `openai_models.py` для удобства.
- Класс **`OpenAIChatBatch`** также принимает и передаёт `base_url` в базовый класс.
- В **`planning_game_models.create_llm_model`** параметр `base_url` из конфига передаётся в модель без изменений (ничего не выкидывается).

Никаких изменений в вызовах API (messages, temperature, seed, logprobs и т.д.) не требуется — OpenRouter принимает те же параметры.

## Как переключиться на OpenRouter

### 1. API-ключ

- Получите ключ на [OpenRouter](https://openrouter.ai/keys).
- Задайте его в конфиге в полях `api_key` для `plan` и `translate` **или** положите в переменную окружения, например `OPENROUTER_API_KEY`, и подставляйте в конфиг при сборке (как сейчас делается с `get_key_openai` для OpenAI).

### 2. Конфигурация

В конфиге для каждого блока `plan` и `translate` добавьте:

- **`base_url`**: `"https://openrouter.ai/api/v1"`
- **`api_key`**: ваш OpenRouter API key (или значение из env).
- **`model_path`**: идентификатор модели на OpenRouter, например:
  - `openai/gpt-4o`
  - `anthropic/claude-3-5-sonnet`
  - `google/gemini-2.0-flash-exp`
  - полный список: [OpenRouter Models](https://openrouter.ai/models)

Пример фрагмента конфига:

```json
"plan": {
  "model_name": "openai_chat",
  "model_path": "openai/gpt-4o",
  "base_url": "https://openrouter.ai/api/v1",
  "api_key": "sk-or-v1-...",
  ...
},
"translate": {
  "model_name": "openai_chat",
  "model_path": "openai/gpt-4o",
  "base_url": "https://openrouter.ai/api/v1",
  "api_key": "sk-or-v1-...",
  ...
}
```

Готовый пример полного конфига: **`configs/templates/react_template_config_openrouter.json`**.

### 3. Переменные окружения (опционально)

Если у вас уже есть скрипт/`set_env`, который подставляет ключ по имени:

- Можно ввести отдельную переменную, например `OPENROUTER_API_KEY`, и в коде генерации конфигов (например, в `generate_steps.py`) для OpenRouter-конфигов подставлять `os.environ.get("OPENROUTER_API_KEY")` вместо `get_key_openai(...)`.
- Или продолжать использовать одну переменную (например, `OPENAI_API_KEY`) и просто записывать в неё OpenRouter-ключ при запуске с OpenRouter-конфигом.

### 4. PDDL describer и другие скрипты

Скрипты вроде `run_planning.py`, `PDDL_describer.py`, `run_batch_openai.py` и т.д. выставляют `openai.api_key = os.environ['OPENAI_API_KEY']` для глобального клиента. Они используются там, где модель создаётся через `create_llm_model()` с конфигом — в этом случае клиент создаётся внутри `OpenAIChatModel` с переданными `api_key` и `base_url` из конфига, так что **для планирования и перевода достаточно правильного конфига**.

Если какой-то скрипт создаёт клиент напрямую через `OpenAI()` без аргументов (например, batch-загрузка файлов), он будет использовать глобальный `openai.api_key` и стандартный URL OpenAI. Для полного перевода таких скриптов на OpenRouter нужно в них создавать клиент явно с `base_url` и ключом OpenRouter (по аналогии с `OpenAIChatModel.create_client()`).

## Рекомендации

1. **Один конфиг — один провайдер**: для OpenRouter используйте отдельные конфиги с `base_url` и `model_path` в формате OpenRouter (`provider/model-id`), не смешивайте в одном конфиге OpenAI и OpenRouter.
2. **Кэш**: при смене `base_url` или `model_path` кэш в `cache_directory` остаётся привязанным к паре модель+путь; для OpenRouter будет другой подкаталог, если в путях кэша участвует `model_path`.
3. **Параметры**: `seed`, `logprobs`, `temperature`, `max_tokens` поддерживаются OpenRouter так же, как в OpenAI; при проблемах сверяйтесь с [документацией OpenRouter](https://openrouter.ai/docs).
4. **Ошибки**: исключения по-прежнему от `openai` (например, `openai.RateLimitError`). При необходимости можно различать OpenAI и OpenRouter по `self.base_url` в коде обработки ошибок.
