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

if [ "$DEPLOY_INFRA" = true ]; then
  echo "==> Deploying infrastructure..."
  ./infrastructure/deploy.sh
  echo
elif [ ! -f infrastructure/config.sh ]; then
  echo "==> No config.sh found, detecting existing infrastructure..."
  RESOURCE_GROUP="dex-registry-rg"
  STORAGE_ACCOUNT=$(az storage account list \
    --resource-group "$RESOURCE_GROUP" \
    --query "[0].name" \
    --output tsv 2>/dev/null || true)

  if [ -n "$STORAGE_ACCOUNT" ]; then
    echo "    Found existing storage account: $STORAGE_ACCOUNT"
    REGISTRY_URL="https://${STORAGE_ACCOUNT}.z13.web.core.windows.net"
    BLOB_ENDPOINT="https://${STORAGE_ACCOUNT}.blob.core.windows.net/"
    cat > infrastructure/config.sh <<EOF
export STORAGE_ACCOUNT="${STORAGE_ACCOUNT}"
export CONTAINER_NAME='\$web'
export REGISTRY_URL="${REGISTRY_URL}"
export BLOB_ENDPOINT="${BLOB_ENDPOINT}"
EOF
  else
    echo "    No existing infrastructure found, deploying..."
    ./infrastructure/deploy.sh
  fi
  echo
fi

source infrastructure/config.sh

# Clean if requested
if [ "$CLEAN" = true ]; then
  echo "==> Cleaning build directory..."
  rm -rf build/
  echo
fi

# The existing registry.json is downloaded from Azure before packaging because
# package.sh wipes and recreates build/. Without this, previously published
# package versions would be lost from the registry on every deploy. The file
# is stashed in /tmp to survive the build/ wipe, then restored afterward so
# generate-registry.py can merge old versions with the current build.
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

# Generate packages metadata
echo "==> Generating packages-meta.json..."
python3 ./scripts/generate-packages-meta.py
echo

echo "==> Copying site files..."
cp -r site/* build/
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
echo "  registry \"reg\" {"
echo "    url = \"$REGISTRY_URL\""
echo "  }"
echo
echo "Then install packages with:"
echo "  dex sync <package-name>"
