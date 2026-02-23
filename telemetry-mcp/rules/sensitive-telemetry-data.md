---
name: sensitive-telemetry-data
description: Protect sensitive information in telemetry data and credentials
---

# Sensitive Telemetry Data Rule

Telemetry data may contain sensitive information. Follow these rules:

- Do NOT include API keys, auth tokens, or credentials in code, commits, or responses
- Telemetry environment variables (PROMETHEUS_URL, GRAFANA_SERVICE_ACCOUNT_TOKEN, DATADOG_API_KEY, etc.) must always be set via environment variables, never hardcoded
- When sharing query results, be aware they may contain PII, internal hostnames, or infrastructure details
- Do NOT log or echo MCP server connection strings that contain credentials
- Remind users to use scoped, least-privilege API keys for telemetry services
