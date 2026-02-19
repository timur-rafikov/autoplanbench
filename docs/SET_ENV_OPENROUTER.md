# Изменения в set_env.py для OpenRouter

Файл `set_env.py` в корне проекта (или в каталоге, откуда импортируется `set_env`) нужно дополнить так.

## 1. Переменные окружения в `set_env_vars()`

Добавьте ключ OpenRouter, чтобы его можно было использовать в скриптах и при вызове `run_domain_setup.py --api-key %OPENROUTER_API_KEY%`:

```python
def set_env_vars():
    os.environ['OPENAI_API_KEY'] = '[KEY]'
    os.environ['OPENROUTER_API_KEY'] = '[OPENROUTER_KEY]'   # добавить: для OpenRouter
    os.environ['FAST_DOWNWARD'] = '[PATH]/fast-downward-22.12'
    os.environ['VAL'] = '[PATH]/VAL'
    os.environ['TOKENIZERS_PARALLELISM'] = 'false'
```

Если не хотите хранить OpenRouter-ключ в коде, можно не задавать его здесь и передавать только через `--api-key` или через переменную окружения, заданную снаружи.

## 2. Идентификатор ключа OpenRouter в `get_key_openai(name)`

`generate_steps.py` подставляет в конфиг ключ через `get_key_openai(api_key_name)`. Чтобы по имени (например, `"openrouter"`) подставлялся ключ OpenRouter, добавьте соответствующую ветку:

```python
def get_key_openai(name: str):
    """
    Set the OPENAI_API_KEY for specific instances of OpenAI clients hence overwriting the value set by the environment variable.
    For OpenRouter, return the OpenRouter key; base_url is set in the config template (e.g. react_template_config_openrouter.json).
    """
    if name == [KEY_IDENTIFIER1]:
        api_key = [ANOTHER API KEY]
    elif name == [KEY_IDENTIFIER2]:
        api_key = [YET ANOTHER API KEY]
    elif name == 'openrouter':   # добавить: идентификатор для OpenRouter
        api_key = os.environ.get('OPENROUTER_API_KEY', '[OPENROUTER_KEY]')
    else:
        api_key = os.environ.get('OPENAI_API_KEY', '[KEY]')  # опционально: fallback по умолчанию
    return api_key
```

Подставьте вместо `[OPENROUTER_KEY]` свой ключ OpenRouter или оставьте чтение только из `OPENROUTER_API_KEY`:

```python
elif name == 'openrouter':
    api_key = os.environ.get('OPENROUTER_API_KEY')
    if not api_key:
        raise ValueError('OPENROUTER_API_KEY not set')
    return api_key
```

## 3. Итоговый пример set_env.py

```python
import os

def set_env_vars():
    os.environ['OPENAI_API_KEY'] = '[KEY]'
    os.environ['OPENROUTER_API_KEY'] = '[OPENROUTER_KEY]'
    os.environ['FAST_DOWNWARD'] = '[PATH]/fast-downward-22.12'
    os.environ['VAL'] = '[PATH]/VAL'
    os.environ['TOKENIZERS_PARALLELISM'] = 'false'

def get_key_openai(name: str):
    if name == [KEY_IDENTIFIER1]:
        api_key = [ANOTHER API KEY]
    elif name == [KEY_IDENTIFIER2]:
        api_key = [YET ANOTHER API KEY]
    elif name == 'openrouter':
        api_key = os.environ.get('OPENROUTER_API_KEY', '[OPENROUTER_KEY]')
    else:
        api_key = os.environ.get('OPENAI_API_KEY')
    return api_key
```

Использование:

- Планирование с OpenRouter: генерировать конфиги из шаблона с `base_url` (например, `react_template_config_openrouter.json`) и передавать `--key openrouter`, чтобы в конфиг подставился ключ из `get_key_openai('openrouter')`.
- Перевод PDDL→NL через OpenRouter: в `run_domain_setup.py` передавать `--base-url https://openrouter.ai/api/v1` и `--api-key` (явно или подставлять `%OPENROUTER_API_KEY%` / `$env:OPENROUTER_API_KEY` после вызова `set_env_vars()`).
