#!/usr/bin/env python3
"""Rebuild registry.json from all tarballs in Azure Blob Storage."""

import json
import re
import subprocess
import sys


def parse_package_filename(filename):
    match = re.match(r'^(.+?)-(\d+\.\d+\.\d+.*?)\.tar\.gz$', filename)
    if match:
        return match.group(1), match.group(2)
    return None, None


def version_key(version_str):
    try:
        parts = version_str.replace('-', '.').replace('+', '.').split('.')
        numeric_parts = []
        for part in parts:
            try:
                numeric_parts.append(int(part))
            except ValueError:
                numeric_parts.append(0)
        return tuple(numeric_parts)
    except Exception:
        return (0,)


def main():
    if len(sys.argv) < 2:
        print("Usage: rebuild-registry-from-azure.py <storage-account-name>")
        sys.exit(1)

    storage_account = sys.argv[1]
    container_name = "$web"

    result = subprocess.run(
        ['az', 'storage', 'blob', 'list',
         '--account-name', storage_account,
         '--container-name', container_name,
         '--auth-mode', 'login',
         '--query', '[].name',
         '-o', 'tsv'],
        capture_output=True, text=True
    )

    if result.returncode != 0:
        print(f"Error listing blobs: {result.stderr}", file=sys.stderr)
        sys.exit(1)

    packages = {}

    for line in result.stdout.strip().split('\n'):
        filename = line.strip()
        if not filename.endswith('.tar.gz'):
            continue

        name, version = parse_package_filename(filename)
        if name and version:
            if name not in packages:
                packages[name] = {"versions": [], "latest": version}
            if version not in packages[name]["versions"]:
                packages[name]["versions"].append(version)

    for name, pkg_data in packages.items():
        pkg_data["versions"].sort(key=version_key)
        pkg_data["latest"] = pkg_data["versions"][-1]

    registry = {"packages": packages}
    print(json.dumps(registry, indent=2))


if __name__ == "__main__":
    main()
