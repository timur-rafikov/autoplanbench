import os
from datetime import datetime
from collections import defaultdict


def get_timestamp_for_log():
    now = str(datetime.now())
    day_now = now.split(' ')[0]
    time_now = now.split(' ')[1]
    time_now = time_now.split('.')[0]  # remove milli sec

    unique_timestamp = day_now + '-' + time_now.replace(':', '-')

    return unique_timestamp


def create_log_file_name(name_prefix: str, file_ending: str):
    time_stamp = get_timestamp_for_log()
    file_name = f'{name_prefix}_{time_stamp}.{file_ending}'
    return file_name


def read_gold_plan(gold_plan_dir: str, task_num: int) -> list:

    gold_plan_file = os.path.join(gold_plan_dir, f'instance-{task_num}_gold_plan.txt')

    gold_actions = read_plan_from_file(pddl_plan_file=gold_plan_file)

    return gold_actions

def read_plan_from_file(pddl_plan_file: str) -> list:

    actions = []
    with open(pddl_plan_file, 'r') as f:
        for line in f.readlines():
            if line.startswith('('):
                actions.append(line.strip())

    return actions


def change_determiners(action_str: str):

    tokens = action_str.split(' ')
    parameter_inds = [ind for ind, token in enumerate(tokens) if token == "{}"]
    for p_ind in parameter_inds:
        potential_determiner = tokens[p_ind - 2]
        if potential_determiner == 'a' or potential_determiner == 'an':
            tokens[p_ind - 2] = 'the'
    action_str = ' '.join(tokens)

    return action_str


def get_llm_type(llm_name: str):
    """Map model name to backend type. openai_chat works for both OpenAI and OpenRouter (same API shape)."""
    if (
        llm_name.startswith('gpt-4')
        or llm_name.startswith('gpt-3.5')
        or llm_name.startswith('gpt-5')
        or llm_name.startswith('openai/')
        or '/' in llm_name
    ):
        return 'openai_chat'
    raise ValueError(
        f'The model {llm_name} could not be mapped to a model type. '
        f'Use --llm-type openai_chat (or openai_comp for completion).'
    )


def find_duplicates(file_paths: list) -> list:
    """
    Finds exact duplicates
    :param file_paths:
    :return: list of lists: each sublist contains the names of all files with the same content
    """
    problem_texts = defaultdict(list)

    for prob_file in file_paths:

        with open(prob_file, 'r') as f:
            problem_text = f.read()
            problem_texts[problem_text].append(prob_file)

    duplicates_list = [pr for pr in problem_texts.values()]
    return duplicates_list

