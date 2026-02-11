#!/usr/bin/env python3
"""Generates a registry.json file from packaged dex tarballs."""

import json
import re
from pathlib import Path


def parse_package_filename(filename):
    """Parse <package-name>-<version>.tar.gz -> (name, version)"""
    match = re.match(r'^(.+?)-(\d+\.\d+\.\d+.*?)\.tar\.gz$', filename)
    if match:
        return match.group(1), match.group(2)
    return None, None


def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    build_dir = project_root / "build"

    if not build_dir.exists():
        print(json.dumps({"packages": {}}, indent=2))
        return

    # Load existing registry if it exists
    packages = {}
    existing_registry_path = build_dir / "registry-existing.json"
    if existing_registry_path.exists():
        try:
            with open(existing_registry_path) as f:
                existing = json.load(f)
                packages = existing.get("packages", {})
        except (json.JSONDecodeError, IOError):
            pass

    # Add/update packages from current build
    for tarball in sorted(build_dir.glob("*.tar.gz")):
        name, version = parse_package_filename(tarball.name)

        if name and version:
            if name not in packages:
                packages[name] = {
                    "versions": [],
                    "latest": version
                }

            if version not in packages[name]["versions"]:
                packages[name]["versions"].append(version)

            packages[name]["latest"] = version

    registry = {"packages": packages}
    print(json.dumps(registry, indent=2))


if __name__ == "__main__":
    main()
