"""
Пересчитывает indefinite-шаблоны экшенов из существующего domain_description_*.json
и обновляет JSON и domain_nl_combined.txt (без вызова LLM).

Использование (из корня проекта):
  python scripts/fix_domain_indefinite_templates.py -d ./data/finance/credit/domain.pddl --d-nl ./data/finance/credit/domain_description_seed0.json
  python scripts/fix_domain_indefinite_templates.py -d ./data/finance/credit/domain.pddl
  (если --d-nl не указан, берётся domain_description_seed0.json в той же папке, что и domain.pddl)
"""
import sys
from pathlib import Path

_root = Path(__file__).resolve().parent.parent
if str(_root) not in sys.path:
    sys.path.insert(0, str(_root))

import json
import argparse
from pddl_processing.PDDL_describer import PDDLDescriber
from utils.run_save_descriptions import write_domain_nl_combined


def main():
    parser = argparse.ArgumentParser(description='Fix indefinite action templates in domain NL JSON (insert type names).')
    parser.add_argument('-d', '--domain', required=True, help='Path to domain.pddl')
    parser.add_argument('--d-nl', default=None, help='Path to domain_description_*.json (default: same dir as domain, domain_description_seed0.json)')
    args = parser.parse_args()

    domain_file = Path(args.domain).resolve()
    if not domain_file.exists():
        print(f'Domain file not found: {domain_file}')
        sys.exit(1)

    if args.d_nl:
        domain_nl_file = Path(args.d_nl).resolve()
    else:
        domain_nl_file = domain_file.parent / 'domain_description_seed0.json'
    if not domain_nl_file.exists():
        print(f'Domain NL file not found: {domain_nl_file}')
        sys.exit(1)

    describer = PDDLDescriber(domain_file=str(domain_file))
    with open(domain_nl_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    action_nl_templates = data.get('action_nl_templates', {})
    if not action_nl_templates:
        print('No action_nl_templates in JSON, nothing to do.')
        sys.exit(0)

    updated = 0
    for action_name in list(action_nl_templates.keys()):
        if action_name not in describer.action_data:
            continue
        template = action_nl_templates[action_name]
        indef_formatted, indef_template = describer.create_action_template_indefinite(
            model_output=template, action_name=action_name
        )
        data.setdefault('action_mappings_indef', {})[action_name] = indef_formatted
        data.setdefault('action_nl_templates_indef', {})[action_name] = indef_template
        updated += 1

    # Regenerate "actions" block (description, preconditions, effects) from updated indef templates,
    # so domain_nl_combined.txt and create_problem_nl_description use the fixed text.
    describer.action_nl_templates_indef = data['action_nl_templates_indef']
    describer.action_mappings_indef = data['action_mappings_indef']
    describer.predicate_nl_templates = data.get('predicate_nl_templates', {})
    describer.action_data = data['actions']
    describer.create_action_description(description_version='medium')
    data['actions'] = describer.action_data

    with open(domain_nl_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)

    combined_path = write_domain_nl_combined(str(domain_nl_file))
    print(f'Updated indefinite templates for {updated} actions; regenerated action descriptions.')
    print(f'Saved: {domain_nl_file}')
    print(f'Refreshed: {combined_path}')


if __name__ == '__main__':
    main()
