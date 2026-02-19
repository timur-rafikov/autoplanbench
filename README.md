# AutoPlanBench

This repository contains the code for AutoPlanBench, a tool to convert PDDL domains and problems into natural language and to run different LLM action choiche mechanisms (both plan generation and action policy) on them.
Additionally, we make our complete dataset available, consisting of NL conversions for a large set of IPC datasets and some additional domains. 

The code and data belongs to the ICAPS'25 paper [Automating the Generation of Prompts for LLM-based Action Choice in PDDL Planning](https://ojs.aaai.org/index.php/ICAPS/article/view/36126)

**Note:** There exist two main versions of this code and the dataset. (See also the [dataset readme](https://github.com/minecraft-saar/autoplanbench/tree/main/autoplanbench_dataset#autoplanbench-dataset) ).

**APB 2.0**
* latest version of the dataset
* containing the same 12 domains as APB 1.0 plus a large number of IPC datasets 
* NL versions generated using OpenAI's GPT-4o model between Aug-Nov, 24 
* corresponds to the newest version of the paper: [Automating the Generation of Prompts for LLM-based Action Choice in PDDL Planning](https://ojs.aaai.org/index.php/ICAPS/article/view/36126)
* current respository corresponds to the latest version of the data and paper

**APB 1.0**
* first version of the dataset
* comprising 12 domains and not including IPC datasets
* NL versions generated using OpenAI's GPT-4 model between Nov, 23 and March, 24
* used for the experiments in the first version of the paper([AutoPlanBench: Automatically generating benchmarks for LLM planners from PDDL](https://arxiv.org/abs/2311.09830v2)) and the (slightly extended) version presented at the  [Workshop on Bridging the Gap Between AI Planning and Reinforcement Learning](https://prl-theworkshop.github.io/prl2024-icaps/) (PRL) at ICAPS 2024 (see the [Website](https://coli-saar.github.io/autoplanbench) or the Workshop website for the paper)
* code is available [here](https://github.com/minecraft-saar/autoplanbench/releases/tag/v1.0)

The code in this repository is made available under the Apache 2.0 license. <br>
The [datasets](https://github.com/minecraft-saar/autoplanbench/tree/main/autoplanbench_dataset) are composed of domain files from different original sources and problems generated using the corresponding generators as well as the datasets from the IPC competitions. For the individual licenses check the respective licenses of the original software/data. 

### Overview

<center>
    <img src="images/autoplanbench.svg" width="40%" />
</center>

This Readme contains the information needed to run the main parts of the project. More detailed information about the different options and configurations, the prompts, evaluation and additional scripts can be found in the [Wiki](https://github.com/minecraft-saar/autoplanbench/wiki).

## Prerequisites

- Linux 
  - This code has only been tested under Linux.
  - It should work on MacOS as well provided the VAL can be compiled successfully
- an OpenAI account 
  - (it is theoretically also possible to run other models such as llama or vicuna. However, we 1) did not test these models on the tasks and cannot tell whether they successfully generate the formats required based on the prompts and few-shot examples from the current repository and 2) there have been several updates to required dependencies since this was set up which cause problems. See the [Wiki]([https://github.com/coli-saar/autoplanbench/wiki/Adding-support-for-additional-LLM-types](https://github.com/minecraft-saar/autoplanbench/wiki/Support-for-additional-LLM-types)) for details on how to add support for other LLM models)

## How to set up Autoplanbench

1. Clone the repository, `cd` into the project directory
2. Install pytorch
   - If you are planning to use models from huggingface, install with CUDA:
     + `conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia`
   - Otherwise, CUDA is not needed:
     + `conda install pytorch torchvision torchaudio cpuonly -c pytorch`
3. Install the requirements
   - `pip install -e .`
4. Download [fastdownward](https://www.fast-downward.org/Releases/22.12)
5. Get and compile [VAL](https://github.com/KCL-Planning/VAL)
6. Create a `set_env.py` file in the project directory using the template below and
   - define the path to fastforward
   - define the path to VAL and specifically the `Validate` binary file (which should be in the directory of the built binary files of VAL)
   - set the API key for openai

```
import os

def set_env_vars():
    os.environ['OPENAI_API_KEY'] = '[KEY]'
    os.environ['FAST_DOWNWARD'] = '[PATH]/fast-downward-22.12'
    os.environ['VAL'] = '[PATH]/VAL'
    os.environ['TOKENIZERS_PARALLELISM'] = 'false'
    
def get_key_openai(name: str):
    """
    Set the OPENAI_API_KEY for specific instances of OpenAI clients hence overwriting the value set by the environment variable
    """
    if name == [KEY_IDENTIFIER1]:
        api_key = [ANOTHER API KEY]
    elif name == [KEY_IDENTIFIER2]:
        api_key = [YET ANOTHER API KEY]
    return api_key 
```

## Running experiments

### Setting up the directory structure for an experiment

This section shows how to run an experiment for a single domain, using the blocksworld domain as an example.

1. Create a folder for the domain in the data directory.
2. Place the `domain.pddl` file of the file in the domain directory.
3. Place the `orig_problems` folder containing the individual instance pddl files in the domain directory.
4. Make sure a folder called `orig_gold_plans` exists in the domain directory, and contains at least the goldplan for the instance to be selected as the few-shot example, but ideally for all instances. If no other instance is specified as the few-shot example later on, the domain setup would expect a gold plan for instance 1 per default. The gold plans for all other instances will be created, if they are missing.

The resulting directory tree will look like this:

```
.
├── ...
└── data
    └── blocksworld
        ├── domain.pddl
        ├── orig_problems
        │   ├── instance_1.pddl
        │   ├── instance_2.pddl
        │   ├── ...
        │   └── instance_n.pddl
        └── orig_gold_plans
            ├── instance_1_gold_plan.txt
            ├── instance_2_gold_plan.txt
            ├── ...
            └── instance_n_gold_plan.txt
```

**NOTE:**
The `DATA_DIR` and `ORIG_INST_FOLDER` variables in
[utils/paths.py](https://github.com/minecraft-saar/autoplanbench/blob/main/utils/paths.py)
can be changed if another data directory or another name for the subfolder
with the problem instances is used. Alternatively different directories can
be specified when running `run_autoplanbench.py`


**Requirements for PDDL:**
The current version of AutoPlanBench covers STRIPS PDDL definitions containing the operators "AND" and "NOT" and that can include *typing* and *negative_preconditions* as requirements. 


### Running the domain setup and planning

This domain setup step will set up all relevant files for the subsequent planning experiments, including few-shot examples and
translations to natural language. The planning step takes care of the running the actual planning experiments.
For both steps, the script `run.py` creates the correct steps in order. It can be used to merely create
shell scripts with the appropriate steps for each domain, to run existing shell scripts or to
do both consecutively. Please note that domain setup and planning need to
be called separately.

#### Usage of `run.py` 

```
run.py [-h] --version {domain_setup,planning}
            --mode {create,run,both}
            --domains DOMAINS [DOMAINS ...]
            [--outfile OUTFILE]
            [--approaches {basic,act,cot,react} [{basic,act,cot,react} ...]]
            [--seeds SEEDS [SEEDS ...]]
            [--fewshot-mappings FEWSHOT_MAPPINGS]
            [--api-key-id API_KEY_ID]
            [--pddl]
```

The individual arguments are as follows:

- `--version`, `-v`: Has to be set to either `domain_setup` or `planning`, depending on which set of commands is up next. To run a complete planning experiment on a domain, `domain_setup` has to be run for that domain first, and afterwards, `planning`.
- `--mode`, `-m`: One of `create`, `run` or `both`.
  + If `create` is chosen. In this case, the shell scripts for the chosen version and configuration are only being generated, but not executed immediately.
  + If `run` is chosen, existing shell scripts for the chosen version and configuration are executed.
  + If `both` is chosen, shell scripts for the chosen version and configuration are only being generated, and executed immediately afterwards.
- `--domains`: Names of the domains to be handled.
- `--approaches`: Which approaches to run, defaults to all for of the four approaches:
  + `basic`: Directly prompts the LLM to generate plans for each of the problems.
  + `act`: Prompts the LLM to generate plans one step at a time, providing immediate domain feedback on the applicability of the selected step.
  + `cot`: Prompts the LLM to use Chain-of-Thought reasoning when generating plans.
  + `react`: Act combined with thoughts - prompts the LLM to generate plans one step at a time using reasoning thoughts, then providing immediate domain feedback.
- `--outfile`: If the commands leading to the creation of the shell scripts for the chosen approach and configuration are to be saved as well, specify a path for output .sh-file.
- `--seeds`: Seeds to be used for the language models.
- `--fewshot-mappings`: File path to the few-shot ID mappings file. Defaults to `data/few_shot_mappings.json`.
- `--api-key-id`: Identifier of the API key to use. Specify the identifiers in `set_env.py` as described above.
- `--pddl`: Set this flag if the input is specified in pddl, note: This is currently only implemented for the approaches basic and act.

#### Domain setup and planning

To return to the example, run domain setup for the blocksworld domain, using the seeds 1, 2 and 3 and the API key associated with the identifier key1 as follows:

```
python run.py --version domain_setup --mode both --domains blocksworld --seeds 1 2 3 --api-key-id key1
```

Run planning for the same configuration:

```
python create_steps_commands.py --version planning --mode both --domains blocksworld --seeds 1 2 3 --api-key-id key1
```


### Running individual steps

For information on how to run individual steps separately, refer to the [Wiki](https://github.com/coli-saar/autoplanbench/wiki/Running-individual-steps).

---

## Scripts reference

All commands below are run from the **project root** (the directory containing `run_domain_setup.py`, `utils/`, `data/`, etc.).

### Environment

Set in the shell (or in `set_env.py` / env file) before running:

```bash
export OPENAI_API_KEY=sk-...          # for OpenAI models
export OPENROUTER_API_KEY=sk-or-...   # optional; for OpenRouter (e.g. gpt-5-mini)
export VAL=/path/to/VAL               # VAL repo root; binary is looked up at VAL/build/bin/Validate or VAL/validate
export FAST_DOWNWARD=/path/to/fast-downward-22.12   # for gold plan generation
```

### 1. Domain setup (`run_domain_setup.py`)

Generates NL descriptions for the domain (predicates and actions), adapts instances, creates gold plans, selects problems, and builds few-shot examples.

```bash
python run_domain_setup.py -o ./data/<domain_dir> --llm <model> [options]
```

**Required:**
- `-o` — output directory for the domain (must contain `domain.pddl` and usually `orig_problems/`).
- `--llm` — model name (e.g. `openai/gpt-4o`, `gpt-5-mini` for OpenRouter).

**Common options:**
- `-d` — path to `domain.pddl` (default: `-o/domain.pddl`).
- `-i` — path to original instances (default: `-o/orig_problems`).
- `-n` — max number of instances to select.
- `--seed` — seed for the LLM (default: random).
- `--parallel N` — number of parallel HTTP requests for PDDL→NL (e.g. `16`); use with OpenRouter for speed. Default `1` (sequential).
- `--no-cache` — disable LLM response cache.
- `--base-url`, `--api-key` — override API endpoint and key (otherwise OpenRouter is used when `OPENROUTER_API_KEY` is set).

**Example (OpenRouter, parallel):**

```bash
python run_domain_setup.py -o ./data/finance3/credit --llm gpt-5-mini --seed 0 --parallel 16
```

Outputs in `-o`: `domain_description_seedN.json`, `domain_nl_combined.txt`, `adapted_instances/`, gold plans, few-shot examples, etc.

### 2. Domain NL only (`utils/run_save_descriptions.py` — type domain)

Build domain encoding from an existing `domain_description_*.json` using a Jinja template.

```bash
python utils/run_save_descriptions.py --type domain --out <path> --d-nl <domain_description_seedN.json> [-t <template>]
```

### 3. Problem (instance) translation (`utils/run_save_descriptions.py` — type instance)

Translate a single PDDL problem to natural language (initial state + goal, and optionally the plan).

```bash
python utils/run_save_descriptions.py --type instance \
  --prob <problem.pddl> \
  --d-nl <domain_description_seedN.json> \
  -d <domain.pddl> \
  --out <output.txt> \
  [--plan <plan.txt> --out-plan <plan_nl.txt>]
```

**Example:**

```bash
python utils/run_save_descriptions.py --type instance \
  --prob ./data/finance3/credit/adapted_instances/problem.pddl \
  --d-nl ./data/finance3/credit/domain_description_seed0.json \
  -d ./data/finance3/credit/domain.pddl \
  --out ./data/finance3/credit/problem_nl.txt
```

### 4. Fix indefinite action templates (`scripts/fix_domain_indefinite_templates.py`)

Recomputes indefinite action templates (and action descriptions) from an existing `domain_description_*.json` so that types appear correctly (e.g. "a drawdown case A" instead of "a A"). Updates the JSON and `domain_nl_combined.txt`.

```bash
python scripts/fix_domain_indefinite_templates.py -d <domain.pddl> [--d-nl <domain_description_seedN.json>]
```

If `--d-nl` is omitted, uses `domain_description_seed0.json` in the same directory as the domain.

### 5. Clear LLM cache for a domain (`scripts/clear_domain_cache.py`)

Removes from the LLM cache only the entries that correspond to a given domain (so the next run refetches from the API).

```bash
python scripts/clear_domain_cache.py -d <domain.pddl> --llm <model> --seed <N> [--d-nl <domain_description_seedN.json>]
```

- `--d-nl` is required for `--to-text extended` (default) so the script can reconstruct cache keys.
- To clear **all** cache for a model, delete the cache directory manually, e.g.  
  `rm -rf llm_caches/openrouter_sdk_<model_path>/`

### 6. Instance setup (`run_instance_setup.py`)

Runs instance adaptation, gold plan generation, and instance selection for an already-configured domain. See `python run_instance_setup.py -h`.

---

**Generating only NL descriptions (summary)**<br>

After domain setup you can regenerate specific outputs:

- **Domain encoding (from template):**  
  `python utils/run_save_descriptions.py --type domain --out [output_path] --d-nl [nl_domain] -t [template_file]`

- **Problem + optional plan:**  
  `python utils/run_save_descriptions.py --type instance --out [output_path] --d-nl [nl_domain] -d [pddl_domain] --prob [pddl_problem] [--plan [pddl_plan] --out-plan [output_path_plan]]`

* `type`: `domain` for domain encoding, `instance` for a problem (and optionally plan).
* `output_path`: path to the output file.
* `nl_domain`: path to the generated `domain_description_*.json`.
* `template_file`: Jinja template for domain encoding (default: `utils.paths.DOMAIN_DESCRIPTION_TEMPLATE`).
* `pddl_domain`: path to the PDDL domain file.
* `pddl_problem`: path to the PDDL problem file.
* `pddl_plan` / `output_path_plan`: optional; if provided, the plan is also converted to NL.

### Output Files

When running the pipeline with `run.py` or `generate_steps.py`, the output
files will be saved to the directory `output_files` per default. Example
output files for the domain blocksworld with the approach react and seed 1
can be seen in this directory.

### Evaluation Results

When running the pipeline with `run.py` or `generate_steps.py`, the evaluation
files will be saved to the directory `evaluation_results` per default.
For each configuration of domain, approach and seed, two files will be saved:
One .csv file with the individual results per instance, and one .csv file
containing a summary with a number of metrics. For a detailed description,
please refer to the [Wiki](https://github.com/minecraft-saar/autoplanbench/wiki/Evaluation-Metrics).
