---
name: telemetry-read-only
description: Default to read-only operations when using telemetry MCP servers to protect production monitoring
---

# Telemetry Read-Only Rule

When using telemetry and observability MCP servers (Prometheus, Grafana, Datadog, CloudWatch, Elasticsearch), **default to read-only operations**.

- Query metrics, logs, and traces freely
- View dashboards, alerts, and monitors
- Do NOT create, modify, or delete dashboards, alerts, monitors, or indices unless explicitly instructed
- Do NOT mute alerts, acknowledge incidents, or change alert states unless explicitly instructed
- Do NOT create or modify Elasticsearch indices unless explicitly instructed
- Always confirm with the user before any write operation to a telemetry system

Telemetry systems are shared production infrastructure. Unintended modifications can affect on-call workflows and monitoring coverage.
