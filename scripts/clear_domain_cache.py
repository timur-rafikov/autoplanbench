"""
Удаляет из кеша LLM только те записи, которые соответствуют заданному домену.
Скрипт не трогает JSON домена — он открывает папку кеша (llm_caches/...), находит
ключи по домену и удаляет их. Для --to-text extended нужен --d-nl (уже сгенерированный
domain_description_*.json), иначе нет шаблонов предикатов для построения ключей.

Использование (из корня проекта):
  python scripts/clear_domain_cache.py -d ./data/finance/credit/domain.pddl --llm openai/gpt-4o --seed 0 --d-nl ./data/finance/credit/domain_description_seed0.json
  python scripts/clear_domain_cache.py -d ./data/finance/credit/domain.pddl --llm openai/gpt-4o --seed 0 --dry-run

Чтобы очистить весь кеш модели (все домены), удалите папку вручную:
  rm -rf llm_caches/openrouter_sdk_openai/gpt-4o/
"""
import sys
import os
from pathlib import Path

_root = Path(__file__).resolve().parent.parent
if str(_root) not in sys.path:
    sys.path.insert(0, str(_root))

import argparse
import json
from diskcache import Cache
from pddl_processing.PDDL_describer import PDDLDescriber
from model_classes.planning_game_models import create_llm_model
from utils.helpers import get_llm_type


def _cache_key(base_messages, user_msg, seed):
    """Тот же формат ключа, что и в parallel_http_openrouter / OpenRouterChatModel.create_cache_query."""
    messages = base_messages + [{"role": "user", "content": user_msg}]
    text_query = ""
    for entry in messages:
        for k, v in entry.items():
            text_query += f"{k}: {v} // "
    return (text_query, seed)


def main():
    parser = argparse.ArgumentParser(description='Clear LLM cache entries for a given domain.')
    parser.add_argument('-d', '--domain', required=True, help='Path to domain.pddl')
    parser.add_argument('--d-nl', default=None, help='Path to domain_description_seedN.json (required for --to-text extended/full)')
    parser.add_argument('--llm', required=True, help='Model name (e.g. openai/gpt-4o)')
    parser.add_argument('--seed', type=int, default=0, help='Seed used when generating (default 0)')
    parser.add_argument('--to-text', default='extended', help='pddl2text_version (default extended)')
    parser.add_argument('--base-url', default=None, help='API base URL (e.g. OpenRouter)')
    parser.add_argument('--api-key', default=None, help='API key (default: OPENROUTER_API_KEY or OPENAI_API_KEY)')
    parser.add_argument('--dry-run', action='store_true', help='Only print how many keys would be deleted')
    parser.add_argument('--verbose', '-v', action='store_true', help='Print cache stats and sample keys to debug')
    args = parser.parse_args()

    domain_file = Path(args.domain).resolve()
    if not domain_file.exists():
        print(f'Domain file not found: {domain_file}')
        sys.exit(1)

    pddl2text_version = args.to_text
    examples_file = _root / 'pddl_processing' / 'examples' / f'examples_mappings_{pddl2text_version}.json'
    if not examples_file.exists():
        print(f'Examples file not found: {examples_file}')
        sys.exit(1)

    model_type = get_llm_type(args.llm)
    base_url = args.base_url
    api_key = args.api_key
    if base_url is None and api_key is None and os.environ.get('OPENROUTER_API_KEY'):
        base_url = 'https://openrouter.ai/api/v1'
        api_key = os.environ.get('OPENROUTER_API_KEY')

    describer = PDDLDescriber(domain_file=str(domain_file))

    # For extended/full we need predicate_nl_templates to build action inputs (preconditions/effects)
    if pddl2text_version in ('extended', 'full'):
        d_nl = args.d_nl
        if not d_nl:
            d_nl = domain_file.parent / f'domain_description_seed{args.seed}.json'
        if not Path(d_nl).exists():
            print(f'For --to-text extended/full pass --d-nl path to domain_description_seedN.json (e.g. {d_nl})')
            sys.exit(1)
        with open(d_nl, 'r', encoding='utf-8') as f:
            nl_data = json.load(f)
        describer.predicate_nl_templates = nl_data.get('predicate_nl_templates', {})

    model_param = {
        'model_name': model_type,
        'model_path': args.llm,
        'max_tokens': 1024,
        'temp': 0,
        'max_history': 1,
        'seed': args.seed,
    }
    if base_url is not None:
        model_param['base_url'] = base_url
    if api_key is not None:
        model_param['api_key'] = api_key
    llm_model = create_llm_model(model_type=model_type, model_param=model_param)

    if not llm_model.cache:
        print('Cache is disabled for this model (no cache directory). Nothing to clear.')
        sys.exit(0)

    seed_val = getattr(llm_model, 'seed', args.seed)

    # Build base_messages for predicates
    prompt_pred, examples_pred = describer.create_prompt(
        prompt_file=str(examples_file), example_keys=['examples_pred'], examples_chat=True
    )
    base_pred = [{"role": "system", "content": prompt_pred}]
    for ex in examples_pred:
        base_pred.append(ex)

    # Build base_messages for actions
    example_keys_act = ['examples_act'] if pddl2text_version != 'full' else ['examples_pred', 'examples_act']
    prompt_act, examples_act = describer.create_prompt(
        prompt_file=str(examples_file), example_keys=example_keys_act, examples_chat=True
    )
    base_act = [{"role": "system", "content": prompt_act}]
    for ex in examples_act:
        base_act.append(ex)

    pred_inputs = describer.create_llm_inputs_predicates()
    act_inputs = describer.create_llm_inputs_actions(pddl2text_version=pddl2text_version)

    keys_to_delete = []
    for _name, inst in pred_inputs.items():
        keys_to_delete.append(_cache_key(base_pred, inst, seed_val))
    for _name, inst in act_inputs.items():
        keys_to_delete.append(_cache_key(base_act, inst, seed_val))

    with Cache(directory=llm_model.cache) as cache:
        if args.verbose:
            cache_keys = list(cache)
            n_cache = len(cache_keys)
            print(f'Keys to delete: {len(keys_to_delete)}, keys in cache: {n_cache}')
            if keys_to_delete:
                k0 = keys_to_delete[0]
                print(f'Our first key: type=({type(k0[0]).__name__}, {type(k0[1]).__name__}), seed={k0[1]!r}, query_len={len(k0[0])}')
                print(f'  query preview: {k0[0][:200]}...')
                print(f'  key in cache? {k0 in cache}')
            if cache_keys:
                c0 = cache_keys[0]
                print(f'Cache first key: type=({type(c0[0]).__name__}, {type(c0[1]).__name__}), seed={c0[1]!r}')
                print(f'  query preview: {(c0[0][:200] if c0[0] else "(empty)")}...')
            if args.dry_run:
                return

        if args.dry_run:
            print(f'Would delete {len(keys_to_delete)} cache keys for domain {domain_file.name} (model={args.llm}, seed={seed_val}).')
            print(f'Cache dir: {llm_model.cache}')
            return

        # Try both int and None for seed (cache might have been written with different type)
        deleted = 0
        for key in keys_to_delete:
            if key in cache:
                del cache[key]
                deleted += 1
            elif isinstance(key[1], int) and key[1] == 0:
                alt = (key[0], None)
                if alt in cache:
                    del cache[alt]
                    deleted += 1
        print(f'Deleted {deleted} cache entries for domain {domain_file.name} (model={args.llm}, seed={seed_val}).')
        print(f'Cache dir: {llm_model.cache}')


if __name__ == '__main__':
    main()
