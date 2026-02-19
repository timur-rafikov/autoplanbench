"""Standalone script to generate domain_nl_combined.txt from domain_description_*.json (no heavy deps)."""
import json
import os
import sys
from pathlib import Path


def main():
    if len(sys.argv) < 2:
        print("Usage: python write_domain_nl_combined_standalone.py <domain_description_seedN.json>")
        sys.exit(1)
    domain_nl_file = sys.argv[1]
    if not os.path.isfile(domain_nl_file):
        print(f"File not found: {domain_nl_file}")
        sys.exit(1)

    with open(domain_nl_file, 'r', encoding='utf-8') as f:
        domain_nl = json.load(f)

    domain_dir = os.path.split(domain_nl_file)[0]
    output_file = os.path.join(domain_dir, 'domain_nl_combined.txt')

    lines = []
    lines.append("=" * 60)
    lines.append("DOMAIN IN NATURAL LANGUAGE")
    lines.append("=" * 60)

    lines.append("\n--- TYPE HIERARCHY ---\n")
    for th in domain_nl.get('type_hierarchy', []):
        lines.append(f"  {th}")
    lines.append("")

    lines.append("\n--- PREDICATES ---\n")
    for pred_name, template in domain_nl.get('predicate_nl_templates', {}).items():
        lines.append(f"  {template}")
    lines.append("")

    lines.append("\n--- ACTIONS ---\n")
    for action_name in domain_nl.get('actions', {}).keys():
        ad = domain_nl['actions'][action_name]
        lines.append(f"  {ad.get('description', '')}")
        for prec in ad.get('preconditions', []):
            lines.append(f"    {prec}")
        for eff in ad.get('effects', []):
            lines.append(f"    {eff}")
        lines.append("")

    Path(domain_dir).mkdir(exist_ok=True)
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write("\n".join(lines))

    print(f"Written: {output_file}")


if __name__ == '__main__':
    main()
