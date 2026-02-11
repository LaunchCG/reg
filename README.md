# Dex Package Registry (nexus-template)

A dex package registry hosted on Azure Blob Storage. Contains development packages for AI-augmented SDLC workflows, code quality, and framework-specific tooling.

**Registry URL:** https://nexustemplateproduction.z13.web.core.windows.net/

## Packages

### Foundation
| Package | Description | Dependencies |
|---------|-------------|--------------|
| `base-dev` | Commit standards, linting, CI/CD, serena + context7 MCP | — |
| `code-review` | Review standards, code-reviewer agent, software engineering patterns | base-dev |
| `nexus-dev` | Nexus AI-SDLC methodology: DoR, DoD, TDD, security scanning | base-dev |
| `jira-tools` | Shared Jira CLI integration using Atlassian CLI wrapper scripts | — |

### SDLC Workflow
| Package | Description | Dependencies |
|---------|-------------|--------------|
| `sdlc-code` | TDD code development (RED-GREEN-REFACTOR) | nexus-dev |
| `sdlc-stories` | User story generation and DoR validation | nexus-dev, jira-tools |
| `sdlc-prd` | Product requirement document generation | nexus-dev |
| `sdlc-architecture` | Architecture documentation and ADR generation | nexus-dev |
| `sdlc-reviewer` | PR review with DoD validation, security, and conventional commits | nexus-dev, code-review |

### Language & Framework
| Package | Description | Dependencies |
|---------|-------------|--------------|
| `python-dev` | Python style, type hints, testing with pytest | — |
| `typescript` | TypeScript linting, testing, Chrome DevTools MCP | — |
| `nextjs` | Next.js 16+ App Router patterns | typescript |
| `tailwind-css` | Tailwind CSS v4 + Material Design 3 | — |
| `vite` | Vite dev server, HMR, build optimization | typescript |
| `mongodb` | MongoDB and Mongoose ODM | typescript |

### Automation
| Package | Description | Dependencies |
|---------|-------------|--------------|
| `frontend-qa` | QA toolkit, Playwright E2E testing | typescript, base-dev |
| `docker-compose` | Docker Compose orchestration | — |
| `github-workflows` | GitHub PR/issue automation | base-dev |

## Install Packages

```bash
# Install dex CLI (https://github.com/LaunchCG/dex)
git clone https://github.com/LaunchCG/dex.git && cd dex && make build && make install

# Initialize your project
cd /path/to/your/project
dex init --agent claude-code
```

Add this registry to your project's `dex.hcl`:

```hcl
registry "nexus-template" {
  url = "https://nexustemplateproduction.z13.web.core.windows.net/"
}
```

Install packages:

```bash
dex install base-dev@0.1.0 -r nexus-template --save
dex install nexus-dev@0.1.0 -r nexus-template --save
dex install sdlc-code@0.1.0 -r nexus-template --save
```

## Deploy the Registry

### Prerequisites
- Azure CLI (`az`) authenticated
- Bicep CLI (bundled with Azure CLI)
- dex CLI
- Python 3

### Deploy Infrastructure + Packages

```bash
# First time: deploy Azure infra and all packages
./deploy.sh --infra

# Subsequent deploys (packages only)
./deploy.sh

# Clean build and redeploy
./deploy.sh --clean
```

### Check Infrastructure Status

```bash
./infrastructure/status.sh
```

Shows the current state of the registry: Azure account, resource group, storage account, static website config, live package list, and local config sync status.

### Infrastructure Only

```bash
./infrastructure/deploy.sh
```

This provisions an Azure Storage Account with static website hosting and public read access on the `$web` container.

### Verify

```bash
source infrastructure/config.sh
curl -s "$REGISTRY_URL/registry.json" | python3 -m json.tool
```

## CI/CD

A GitHub Actions workflow (`.github/workflows/deploy.yml`) deploys automatically on push to `main`.

### One-Time Setup

Requires someone with **Owner** or **User Access Administrator** role on the Azure subscription:

```bash
./infrastructure/setup-github-oidc.sh
```

This creates:
- Azure AD app registration (`dex-registry-github-actions`)
- Service principal with Contributor role on `dex-registry-rg`
- Federated identity credentials for GitHub Actions OIDC (no secrets to rotate)

And sets three GitHub repository secrets:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

**Prerequisites for setup script:**
- Azure CLI authenticated (`az login`) with Owner or User Access Administrator
- GitHub CLI authenticated (`gh auth login`) with repo admin access
- The `dex` CLI must be available on the GitHub Actions runner

### How It Works

The workflow uses [Azure OIDC](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation) — GitHub Actions exchanges a short-lived token with Azure AD on each run. No long-lived secrets to manage or rotate.

## Project Structure

```
nexus-template/
├── dex.hcl                     # Project config
├── deploy.sh                   # Root deploy script
├── infrastructure/
│   ├── main.bicep              # Azure Blob Storage
│   ├── parameters.json         # Bicep parameters
│   ├── deploy.sh               # Infra deploy script
│   └── status.sh               # Check provisioned infrastructure
├── scripts/
│   ├── package.sh              # Build all packages
│   ├── generate-registry.py    # Generate registry.json
│   └── rebuild-registry-from-azure.py  # Recovery tool
├── base-dev/                   # Package directories...
├── code-review/
├── nexus-dev/
├── jira-tools/
├── sdlc-code/
├── sdlc-stories/
├── sdlc-prd/
├── sdlc-architecture/
├── sdlc-reviewer/
├── python-dev/
├── typescript/
├── nextjs/
├── tailwind-css/
├── vite/
├── mongodb/
├── frontend-qa/
├── docker-compose/
└── github-workflows/
```

## License

MIT
