<!-- dex:local-stack-setup -->
---
name: local-stack-setup
description: How to start, stop, and use the local telemetry stack (Prometheus, Grafana, OTEL Collector, Elasticsearch, Loki)
---

# Local Telemetry Stack

You know how to spin up and manage the local telemetry stack for development. Installing the `telemetry-stack` package distributes all infrastructure config files to `.dex/stacks/telemetry-stack/` in the project root. All stack operations use runbook MCP tasks — never direct Bash commands.

## When to Use This Skill

Use when:
- Starting the local observability infrastructure for development
- Connecting a local app to send traces, metrics, or logs
- Troubleshooting why telemetry signals are not appearing
- Generating a Grafana token to connect the `telemetry-mcp` MCP servers to the local stack

## Stack Overview

| Service | Purpose | Port |
|---------|---------|------|
| OTEL Collector | Receives OTLP signals, routes to backends | 4317 (gRPC), 4318 (HTTP) |
| Prometheus | Stores and queries metrics | 9090 |
| Grafana | Dashboards and log viewer | 3000 |
| Loki | Stores and queries logs | 3100 |
| Elasticsearch | Stores logs and traces | 9200 |

All services share the Docker network `nexus-telemetry-network`.

## What Gets Installed

After installing `telemetry-stack`, the project root contains:
```
.dex/stacks/telemetry-stack/
├── docker-compose.telemetry.yml
├── otel-collector.yml
├── prometheus.yml
└── grafana/
    ├── datasources.yml
    └── dashboards/
        ├── dashboards.yml
        └── nexus-overview.json
.runbook/
└── telemetry-stack.yaml
```

## Stack Operations

Always use the runbook MCP tasks — never run docker compose commands directly via Bash.

| Goal | Runbook Task |
|------|-------------|
| Start the stack | `start-stack` |
| Stop the stack | `stop-stack` |
| Check container status | `stack-status` |
| View service logs | `stack-logs` (with `service` parameter) |
| Get Grafana token | `get-grafana-token` |
| Restart a service | `restart-service` (with `service` parameter) |

## First-Time Setup

The stack is self-configuring on first start:
1. Grafana auto-provisions Prometheus, Loki, and Elasticsearch as datasources.
2. The `Nexus Local` dashboard folder is created with a starter overview dashboard.
3. Elasticsearch creates `otel-logs` and `otel-traces` indices on first write.

**Grafana credentials:** `admin` / `nexus-local` (local dev only)

## Getting a Grafana Token for `telemetry-mcp`

To use the Grafana MCP server with the local stack, run the `get-grafana-token` task after the stack is running. It outputs:
```
export GRAFANA_URL=http://localhost:3000
export GRAFANA_SERVICE_ACCOUNT_TOKEN=glsa_...
```
Set these environment variables and restart Claude Code.

## Connecting Apps to the Stack

### Option A: Host network (non-containerized apps)
```bash
export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
export OTEL_EXPORTER_OTLP_PROTOCOL=grpc
export OTEL_SERVICE_NAME=my-service
```

### Option B: Join the Docker network (containerized apps — recommended)
Add to your app's `docker-compose.yml`:
```yaml
networks:
  app-network:
    driver: bridge
  nexus-telemetry:
    external: true
    name: nexus-telemetry-network

services:
  my-service:
    # ...
    environment:
      OTEL_EXPORTER_OTLP_ENDPOINT: http://nexus-otel-collector:4317
      OTEL_EXPORTER_OTLP_PROTOCOL: grpc
      OTEL_SERVICE_NAME: my-service
    networks:
      - app-network
      - nexus-telemetry
```

## Verifying Data Flow

1. **Prometheus:** http://localhost:9090/targets — `otel-collector-metrics` should show UP.
2. **OTEL Collector:** http://localhost:13133 — returns `{"status":"Server available"}`.
3. **Grafana:** http://localhost:3000 — open `Nexus Local > Nexus Local Overview`.
4. **Loki:** In Grafana Explore, select the Loki datasource, query `{job=~".+"}`.
5. **Elasticsearch:** `curl http://localhost:9200/otel-logs/_count`

## Troubleshooting

**Port already in use:** Ensure 3000, 4317, 4318, 9090, 9200, 3100 are free before starting.

**Elasticsearch slow to start:** ES takes 60–90 seconds on first boot. Use `stack-status` to monitor the health check.

**Linux only — Elasticsearch fails with "max virtual memory areas vm.max_map_count is too low":**
```bash
sudo sysctl -w vm.max_map_count=262144
# To persist: add vm.max_map_count=262144 to /etc/sysctl.conf
```

**No metrics in Prometheus:** Check `http://localhost:8889/metrics` on the OTEL Collector directly. If metrics appear there, the Prometheus scrape config is the issue. If not, verify your app is sending OTLP to port 4317.

<!-- /dex:local-stack-setup -->
