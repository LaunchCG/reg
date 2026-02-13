#!/usr/bin/env python3
"""Generates packages-meta.json with enriched metadata from all package.hcl files."""

import json
import re
from pathlib import Path


def parse_string_field(content, field):
    """Extract a quoted string value for a top-level field inside the package block."""
    pattern = rf'^\s+{field}\s*=\s*"([^"]*)"'
    match = re.search(pattern, content, re.MULTILINE)
    return match.group(1) if match else None


def parse_platforms(content):
    """Extract the platforms array from the package block."""
    match = re.search(r'platforms\s*=\s*\[([^\]]*)\]', content)
    if not match:
        return []
    raw = match.group(1)
    return re.findall(r'"([^"]+)"', raw)


def parse_dependencies(content):
    """Extract dependency blocks: name and version constraint."""
    deps = []
    for match in re.finditer(
        r'dependency\s+"([^"]+)"\s*\{[^}]*version\s*=\s*"([^"]+)"', content
    ):
        deps.append({"name": match.group(1), "version": match.group(2)})
    return deps


def count_blocks(content, block_type):
    """Count named HCL blocks of a given type (e.g. claude_skill, mcp_server)."""
    pattern = rf'^{re.escape(block_type)}\s+"[^"]+"\s*\{{'
    return len(re.findall(pattern, content, re.MULTILINE))


def parse_package_hcl(hcl_path):
    """Parse a single package.hcl and return its metadata dict."""
    content = hcl_path.read_text()

    name = parse_string_field(content, "name")
    if not name:
        return None

    # Count resources using claude_* blocks (canonical, not copilot_ duplicates)
    skills = count_blocks(content, "claude_skill")
    rules = count_blocks(content, "claude_rule") + count_blocks(content, "claude_rules")
    commands = count_blocks(content, "claude_command")
    subagents = count_blocks(content, "claude_subagent")
    mcp_servers = count_blocks(content, "mcp_server")

    return {
        "name": name,
        "version": parse_string_field(content, "version"),
        "description": parse_string_field(content, "description"),
        "platforms": parse_platforms(content),
        "dependencies": parse_dependencies(content),
        "resources": {
            "skills": skills,
            "rules": rules,
            "commands": commands,
            "subagents": subagents,
            "mcp_servers": mcp_servers,
        },
    }


def main():
    project_root = Path(__file__).parent.parent
    build_dir = project_root / "build"
    build_dir.mkdir(exist_ok=True)

    packages = []

    for hcl_path in sorted(project_root.glob("*/package.hcl")):
        meta = parse_package_hcl(hcl_path)
        if meta:
            packages.append(meta)

    packages.sort(key=lambda p: p["name"])

    output = {
        "total_packages": len(packages),
        "packages": packages,
    }

    out_path = build_dir / "packages-meta.json"
    out_path.write_text(json.dumps(output, indent=2) + "\n")
    print(f"Generated {out_path} ({len(packages)} packages)")


if __name__ == "__main__":
    main()
