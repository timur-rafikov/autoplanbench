import os
import sys
from pathlib import Path

# Ensure project root is on path when running as python utils/run_save_descriptions.py
_root = Path(__file__).resolve().parent.parent
if str(_root) not in sys.path:
    sys.path.insert(0, str(_root))

import json
from jinja2 import Template
from typing import Union
from argparse import ArgumentParser
from llm_planning.game_classes.pddl_game_env import PDDLWorldEnvironment
from utils.paths import DOMAIN_DESCRIPTION_TEMPLATE
from set_env import set_env_vars

set_env_vars()


def create_domain_nl_description(domain_nl_file: str,
                                 output_file: Union[str, None] = None,
                                 template_file: str = DOMAIN_DESCRIPTION_TEMPLATE):
    """
    Creates the NL encoding of a domain in the format specified in the template file and saves it to an output file
    :param domain_nl_file: path to the domain nl .json file
    :param output_file: path to the text file for the output
    :param template_file: path to a jinja template file
    :return:
    """

    with open(template_file, 'r') as f:
        template = Template(f.read())

    with open(domain_nl_file, 'r') as f:
        domain_nl = json.load(f)

    if not output_file:
        domain_dir = os.path.split(domain_nl_file)[0]
        output_file = os.path.join(domain_dir, 'domain_encoding.txt')

    preconditions = []
    effects = []
    for action in domain_nl['actions'].keys():
        preconditions.extend(domain_nl['actions'][action]['preconditions'])
        effects.extend(domain_nl['actions'][action]['effects'])

    actions = []
    for action_name in domain_nl['actions'].keys():
        actions.append(domain_nl['actions'][action_name]['description'])
    actions = '\n'.join(actions)

    template_args = {
        'actions': actions,
        'preconditions': preconditions,
        'effects': effects,
        'type_hierarchy': domain_nl['type_hierarchy']
    }

    domain_description = template.render(**template_args)

    output_dir = os.path.split(output_file)[0]
    Path(output_dir).mkdir(exist_ok=True)

    with open(output_file, 'w') as file:
        file.write(domain_description)


def write_domain_nl_combined(domain_nl_file: str, output_file: Union[str, None] = None):
    """
    Writes one combined human-readable file with the full PDDL domain translated to natural language:
    type hierarchy, all predicates (PDDL -> NL template), all actions (description, preconditions, effects).
    """
    with open(domain_nl_file, 'r', encoding='utf-8') as f:
        domain_nl = json.load(f)

    if output_file is None:
        domain_dir = os.path.split(domain_nl_file)[0]
        output_file = os.path.join(domain_dir, 'domain_nl_combined.txt')

    lines = []
    lines.append("=" * 60)
    lines.append("DOMAIN IN NATURAL LANGUAGE")
    lines.append("=" * 60)

    # Type hierarchy
    lines.append("\n--- TYPE HIERARCHY ---\n")
    for th in domain_nl.get('type_hierarchy', []):
        lines.append(f"  {th}")
    lines.append("")

    # Predicates: only NL templates
    lines.append("\n--- PREDICATES ---\n")
    for pred_name, template in domain_nl.get('predicate_nl_templates', {}).items():
        lines.append(f"  {template}")
    lines.append("")

    # Actions: only NL description, preconditions, effects
    lines.append("\n--- ACTIONS ---\n")
    for action_name in domain_nl.get('actions', {}).keys():
        ad = domain_nl['actions'][action_name]
        lines.append(f"  {ad.get('description', '')}")
        for prec in ad.get('preconditions', []):
            lines.append(f"    {prec}")
        for eff in ad.get('effects', []):
            lines.append(f"    {eff}")
        lines.append("")

    output_dir = os.path.split(output_file)[0]
    Path(output_dir).mkdir(exist_ok=True)
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("\n".join(lines))

    return output_file


def _nl_clean(s: str) -> str:
    """Human-readable: replace underscores and hyphens with spaces."""
    return s.replace('_', ' ').replace('-', ' ') if isinstance(s, str) else s


def create_problem_nl_description(problem_file: str,
                                  domain_nl_file: str,
                                  domain_pddl_file: str,
                                  output_file: str,
                                  plan_file: str = '',
                                  plan_out_file: str = ''):

    with open(domain_nl_file, 'r') as df:
        domain_nl = json.load(df)

    domain_env = PDDLWorldEnvironment(domain_nl=domain_nl,
                                      instance_file=problem_file,
                                      domain_file=domain_pddl_file,
                                      nlp_processor=None)

    initial_state = _nl_clean(domain_env.get_description_initial_state())
    goal_state = _nl_clean(domain_env.get_description_goal_state())

    output_folder = os.path.split(output_file)[0]
    Path(output_folder).mkdir(exist_ok=True)
    with open(output_file, 'w') as f:
        f.write(f'{initial_state}\n\n')
        f.write(f'{goal_state}')

    if plan_file != '':
        nl_plan = []
        with open(plan_file, 'r') as f:
            for line in f.readlines():
                cleaned_line = line.strip()
                if cleaned_line.startswith(';'):
                    continue
                cleaned_line = cleaned_line.split(';')[0]
                action_str = domain_env.get_description_action(action=cleaned_line)
                nl_plan.append(_nl_clean(action_str))

        with open(plan_out_file, 'w') as f:
            for action_str in nl_plan:
                f.write(f'{action_str}\n')


def create_readable_few_shot(example_file: str, output_file: str):

    with open(example_file, 'r') as ef:
        few_shot = json.load(ef)

    prefixes = few_shot['prefixes']
    examples = few_shot['pos_examples']

    examples_text = ''
    for ex in examples:

        input = f'{prefixes["input"]}{ex[0]}'
        output = f'{prefixes["output"]}{ex[1]}'

        examples_text += f'{input}\n{output}\n\n'

    output_folder = os.path.split(output_file)[0]
    Path(output_folder).mkdir(exist_ok=True)
    with open(output_file, 'w') as f:
        f.write(examples_text)


if __name__ == '__main__':

    parser = ArgumentParser()
    parser.add_argument('--type', required=True, help='Which type of description to generate. Can be "domain", "example" or "instance"')
    parser.add_argument('--out', required=True, help='Path to the file where the descriptions is saved to')
    parser.add_argument('-t', required=False, default=None, help='Path to the jinja template file for the domain descriptions')
    parser.add_argument('--prob', required=False, default=None, help='Path to the problem pddl file for which description is generated')
    parser.add_argument('--d-nl', required=False, default=None, help='Path to the NL domain .json file')
    parser.add_argument('-d', required=False, default=None, help='Path to the PDDL domain file')
    parser.add_argument('--out-plan', required=False, default='', help='Path to the output file for the plan')
    parser.add_argument('--plan', required=False, default='', help='Path to the PDDL plan file')
    parser.add_argument('-e', required=False, default=None, help='Path to the example file to convert in human readable format')

    args = parser.parse_args()

    if args.t is None:
        template_file = DOMAIN_DESCRIPTION_TEMPLATE
    else:
        template_file = args.t

    descrip_type = args.type
    if descrip_type == 'domain':
        assert args.d_nl
        create_domain_nl_description(domain_nl_file=args.d_nl,
                                     output_file=args.out,
                                     template_file=template_file)
    elif descrip_type == 'example':
        assert args.e
        create_readable_few_shot(example_file=args.e,
                                 output_file=args.out)
    elif descrip_type == 'instance':
        assert args.d and args.prob and args.d_nl
        create_problem_nl_description(problem_file=args.prob, domain_nl_file=args.d_nl, domain_pddl_file=args.d,
                                      output_file=args.out, plan_file=args.plan, plan_out_file=args.out_plan)
    else:
        raise NotImplementedError




