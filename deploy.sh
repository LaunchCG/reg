#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Parse args
DEPLOY_INFRA=false
CLEAN=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --infra) DEPLOY_INFRA=true; shift ;;
    --clean) CLEAN=true; shift ;;
    *) echo "Unknown: $1"; echo "Usage: $0 [--infra] [--clean]"; exit 1 ;;
  esac
done

# Deploy infra if requested
if [ "$DEPLOY_INFRA" = true ]; then
  echo "==> Deploying infrastructure..."
  ./infrastructure/deploy.sh
  echo
fi

# Source config
if [ ! -f infrastructure/config.sh ]; then
  echo "Error: infrastructure/config.sh not found"
  echo "Run with --infra flag first"
  exit 1
fi
source infrastructure/config.sh

# Clean if requested
if [ "$CLEAN" = true ]; then
  echo "==> Cleaning build directory..."
  rm -rf build/
  echo
fi

# Download existing registry.json from Azure to preserve old versions
echo "==> Downloading existing registry.json from Azure..."
mkdir -p build/
if az storage blob download \
  --account-name "$STORAGE_ACCOUNT" \
  --container-name "$CONTAINER_NAME" \
  --name "registry.json" \
  --file build/registry-existing.json \
  --auth-mode key 2>/dev/null; then
  echo "Found existing registry.json"
  cp build/registry-existing.json /tmp/registry-existing.json
else
  echo "No existing registry.json found (normal for first deployment)"
  echo '{"packages":{}}' > /tmp/registry-existing.json
fi
echo

# Package
echo "==> Packaging dex packages..."
./scripts/package.sh
echo

# Restore existing registry for version merge
echo "==> Restoring existing registry for version merge..."
cp /tmp/registry-existing.json build/registry-existing.json
echo

# Upload to Azure Blob Storage $web container
echo "==> Uploading to Azure Blob Storage..."
az storage blob upload-batch \
  --account-name "$STORAGE_ACCOUNT" \
  --destination "$CONTAINER_NAME" \
  --source build/ \
  --overwrite \
  --auth-mode key \
  --pattern "*"
echo

echo "==> Deployment complete!"
echo "Registry URL: $REGISTRY_URL"
echo
echo "Add to your project's dex.hcl:"
echo "  registry \"nexus-template\" {"
echo "    url = \"$REGISTRY_URL\""
echo "  }"
echo
echo "Then install packages with:"
echo "  dex install nexus-dev@0.1.0 -r nexus-template --save"
