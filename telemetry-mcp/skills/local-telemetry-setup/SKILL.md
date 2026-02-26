<!-- dex:local-telemetry-setup -->
---
name: local-telemetry-setup
description: Configure telemetry-mcp MCP servers to connect to a locally running telemetry stack
mcpServers:
  - prometheus
  - grafana
  - elasticsearch
---

# Local Telemetry Setup

You know how to configure the `telemetry-mcp` MCP servers to point at the local telemetry stack running via the `telemetry-stack` package.

## When to Use This Skill

Use when:
- Switching from cloud/production telemetry endpoints to a local development stack
- Setting up a local investigation workflow with the `observability-investigation` skill
- Generating and applying the Grafana token for the local stack

## Environment Variables for Local Stack

Set these before starting Claude Code:

```bash
# Prometheus MCP server
export PROMETHEUS_URL=http://localhost:9090

# Grafana MCP server — generate token with get-grafana-token runbook task
export GRAFANA_URL=http://localhost:3000
export GRAFANA_SERVICE_ACCOUNT_TOKEN=glsa_...

# Elasticsearch MCP server — no API key needed for local stack
export ES_URL=http://localhost:9200
export ES_API_KEY=
```

The `prometheus-mcp` server reads `PROMETHEUS_URL` automatically. The `grafana` and `elasticsearch` MCP servers use `${GRAFANA_URL}`, `${GRAFANA_SERVICE_ACCOUNT_TOKEN}`, `${ES_URL}`, and `${ES_API_KEY}` — the env var names must match exactly.

## Getting a Grafana Token

Use the `get-grafana-token` runbook task from the `telemetry-stack` package. Make sure the stack is running first (`start-stack` task), then run `get-grafana-token`. Copy and export the printed values.

## Available Backends Locally

| MCP Server | Local URL | Data |
|------------|-----------|------|
| prometheus | http://localhost:9090 | Metrics from OTEL-instrumented apps |
| grafana | http://localhost:3000 | Dashboards, Loki log exploration |
| elasticsearch | http://localhost:9200 | OTEL traces (`otel-traces`) and logs (`otel-logs`) |

`datadog` and `cloudwatch` MCP servers have no local equivalent — skip them during local investigations.

## Local Investigation Workflow

1. Start the stack: `start-stack` runbook task.
2. Instrument your app (see the `app-instrumentation` skill in the `telemetry-stack` package) and send traffic.
3. Set the env vars above and restart Claude Code.
4. Use the `observability-investigation` skill — all queries now hit the local stack.
5. Use the `promql-guide` skill for PromQL queries against local Prometheus.
6. Use the `log-analysis` skill for Elasticsearch queries against local `otel-logs` and `otel-traces` indices.

<!-- /dex:local-telemetry-setup -->
