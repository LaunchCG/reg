package {
  name        = "telemetry-mcp"
  version     = "0.1.0"
  description = "Observability and telemetry toolkit with MCP servers for Prometheus, Grafana, Datadog, CloudWatch, and Elasticsearch"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "base-dev" {
  version = ">=0.1.0"
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
  description = "Search and analyze Elasticsearch indices and documents"
  command     = "npx"
  args        = ["-y", "elasticsearch-mcp@latest"]
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

# --- Claude Rules ---

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
