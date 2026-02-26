package {
  name        = "telemetry-mcp"
  version     = "0.2.0"
  description = "Observability and telemetry toolkit with MCP servers for Prometheus, Grafana, Datadog, CloudWatch, and Elasticsearch"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "base-dev" {
  version = ">=0.1.0"
}

dependency "telemetry-stack" {
  version = ">=0.1.2"
}

# --- MCP Servers ---

mcp_server "prometheus" {
  description = "Query and analyze Prometheus metrics via PromQL"
  command     = "npx"
  args        = ["-y", "prometheus-mcp@latest", "stdio"]
}

mcp_server "grafana" {
  description = "Access Grafana dashboards, alerts, incidents, and observability data"
  command     = "npx"
  args        = ["-y", "@leval/mcp-grafana"]
  env = {
    GRAFANA_URL                   = "$${GRAFANA_URL}"
    GRAFANA_SERVICE_ACCOUNT_TOKEN = "$${GRAFANA_SERVICE_ACCOUNT_TOKEN}"
  }
}

mcp_server "datadog" {
  description = "Search Datadog logs, metrics, traces, monitors, and dashboards"
  command     = "npx"
  args        = ["-y", "@winor30/mcp-server-datadog"]
}

mcp_server "cloudwatch" {
  description = "Query AWS CloudWatch Logs with Log Insights"
  command     = "npx"
  args        = ["-y", "@teolin/mcp-cloudwatch-logs"]
}



mcp_server "elasticsearch" {
  description = "Query and analyze Elasticsearch indices, mappings, and documents"
  command     = "npx"
  args        = ["-y", "@elastic/mcp-server-elasticsearch"]
  env = {
    ES_URL     = "$${ES_URL}"
    ES_API_KEY = "$${ES_API_KEY}"
  }
}

# --- Claude Skills ---

claude_skill "observability-investigation" {
  description = "Systematic approach to investigating production issues using metrics, logs, and traces"
  content     = file("skills/observability-investigation/SKILL.md")
}

claude_skill "promql-guide" {
  description = "PromQL query patterns for common monitoring scenarios including RED and USE methods"
  content     = file("skills/promql-guide/SKILL.md")
}

claude_skill "log-analysis" {
  description = "Log query patterns for CloudWatch Logs Insights, Elasticsearch, and Grafana Loki"
  content     = file("skills/log-analysis/SKILL.md")
}

claude_skill "local-telemetry-setup" {
  description = "Configure MCP servers to connect to a locally running telemetry stack"
  content     = file("skills/local-telemetry-setup/SKILL.md")
}

# --- Claude Rules ---

claude_rule "telemetry-stack-lifecycle" {
  description = "Verify telemetry stack is running before using telemetry MCP servers"
  content     = <<-EOT
    Before using any telemetry MCP servers (prometheus, grafana, elasticsearch), you must verify the local telemetry stack is running.

    The telemetry stack is a SEPARATE Docker Compose stack from the application. Do not confuse it with the project's own docker-compose.yml. The telemetry stack runs Prometheus, Grafana, OTEL Collector, Elasticsearch, and Loki — not application services.

    To check telemetry stack status: use the runbook MCP tool with task_name "stack-status" from the telemetry-stack task set (.runbook/telemetry-stack.yaml). The running containers will be named nexus-prometheus, nexus-grafana, nexus-otel-collector, nexus-elasticsearch, and nexus-loki.

    If those containers are not running: use the runbook MCP tool with task_name "start-stack" from the telemetry-stack task set. Do NOT use dc-rebuild-service or any other docker-compose task — those operate on the application stack.

    Do not attempt to query prometheus, grafana, or elasticsearch MCP servers until their containers are confirmed running.
  EOT
}

claude_rule "telemetry-read-only" {
  description = "Default to read-only operations when using telemetry MCP servers"
  content     = file("rules/telemetry-read-only.md")
}

claude_rule "sensitive-telemetry-data" {
  description = "Protect sensitive information in telemetry data and credentials"
  content     = file("rules/sensitive-telemetry-data.md")
}

# --- Claude Agent ---

claude_subagent "incident-investigator" {
  description = "Specialized agent for investigating production incidents using observability data"
  content     = file("agents/incident-investigator.md")
}

# --- MCP Permissions ---

claude_settings "mcp-permissions" {
  allow = [
    "mcp__prometheus__*",
    "mcp__grafana__*",
    "mcp__datadog__*",
    "mcp__cloudwatch__*",
    "mcp__elasticsearch__*"
  ]
}

# --- Copilot Resources ---

copilot_skill "observability-investigation" {
  description = "Systematic approach to investigating production issues using metrics, logs, and traces"
  content     = file("skills/observability-investigation/SKILL.md")
}

copilot_skill "promql-guide" {
  description = "PromQL query patterns for common monitoring scenarios"
  content     = file("skills/promql-guide/SKILL.md")
}

copilot_skill "log-analysis" {
  description = "Log query patterns for CloudWatch, Elasticsearch, and Loki"
  content     = file("skills/log-analysis/SKILL.md")
}

copilot_skill "local-telemetry-setup" {
  description = "Configure MCP servers to connect to a locally running telemetry stack"
  content     = file("skills/local-telemetry-setup/SKILL.md")
}

copilot_instruction "telemetry-read-only" {
  description = "Default to read-only operations when using telemetry MCP servers"
  content     = file("rules/telemetry-read-only.md")
}

copilot_instruction "sensitive-telemetry-data" {
  description = "Protect sensitive information in telemetry data and credentials"
  content     = file("rules/sensitive-telemetry-data.md")
}

copilot_agent "incident-investigator" {
  description = "Specialized agent for investigating production incidents using observability data"
  content     = file("agents/incident-investigator.md")
}
