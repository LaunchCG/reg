package {
  name        = "telemetry-stack"
  version     = "0.1.2"
  description = "Local telemetry infrastructure: Prometheus, Grafana, OTEL Collector, Elasticsearch, and Loki via Docker Compose"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "docker-compose" {
  version = ">=0.2.0"
}

# --- Distribute infrastructure config files ---
# Files land at .dex/stacks/telemetry-stack/ in the user's project root.
# Docker volume mounts and task commands reference this path.

file "docker-compose" {
  src  = "infra/docker-compose.telemetry.yml"
  dest = ".dex/stacks/telemetry-stack/docker-compose.telemetry.yml"
}

file "otel-collector-config" {
  src  = "infra/otel-collector.yml"
  dest = ".dex/stacks/telemetry-stack/otel-collector.yml"
}

file "prometheus-config" {
  src  = "infra/prometheus.yml"
  dest = ".dex/stacks/telemetry-stack/prometheus.yml"
}

file "grafana-datasources" {
  src  = "infra/grafana/datasources.yml"
  dest = ".dex/stacks/telemetry-stack/grafana/datasources.yml"
}

file "grafana-dashboards-provisioning" {
  src  = "infra/grafana/dashboards/dashboards.yml"
  dest = ".dex/stacks/telemetry-stack/grafana/dashboards/dashboards.yml"
}

file "grafana-overview-dashboard" {
  src  = "infra/grafana/dashboards/nexus-overview.json"
  dest = ".dex/stacks/telemetry-stack/grafana/dashboards/nexus-overview.json"
}

file "tasks" {
  src  = "tasks.yaml"
  dest = ".runbook/telemetry-stack.yaml"
}

# --- Skills ---

claude_skill "local-stack-setup" {
  description = "How to start, stop, and use the local telemetry stack for development"
  content     = file("skills/local-stack-setup/SKILL.md")
}

claude_skill "app-instrumentation" {
  description = "OTEL instrumentation patterns for Python/FastAPI and Node.js to publish telemetry to the local stack"
  content     = file("skills/app-instrumentation/SKILL.md")
}

# --- Rules ---

claude_rule "telemetry-stack-mcp-rule" {
  description = "Enforce MCP usage for telemetry stack operations"
  content     = "You must use the runbook MCP tools for all telemetry stack operations (start, stop, status, logs). Never run docker compose commands directly via Bash for the telemetry stack."
}

# --- Copilot Resources ---

copilot_skill "local-stack-setup" {
  description = "How to start, stop, and use the local telemetry stack for development"
  content     = file("skills/local-stack-setup/SKILL.md")
}

copilot_skill "app-instrumentation" {
  description = "OTEL instrumentation patterns for Python/FastAPI and Node.js"
  content     = file("skills/app-instrumentation/SKILL.md")
}
