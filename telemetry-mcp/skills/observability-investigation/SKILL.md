---
name: observability-investigation
description: Systematic approach to investigating production issues using metrics, logs, and traces
allowed-tools: mcp__prometheus__*, mcp__grafana__*, mcp__datadog__*, mcp__cloudwatch__*, mcp__elasticsearch__*
mcpServers:
  - prometheus
  - grafana
  - datadog
  - cloudwatch
  - elasticsearch
---

# Observability Investigation Skill

A structured approach to investigating production issues by correlating signals across metrics, logs, and traces from multiple telemetry sources.

## When This Skill is Invoked

This skill will be used when you mention:
- "investigate production issue"
- "diagnose outage"
- "check system health"
- "why is the service slow"
- "error rate spike"
- "observability" or "telemetry"

## Core Principle: Metrics, Logs, Traces

Each telemetry signal answers a different question:

| Signal | Question | Sources |
|--------|----------|---------|
| **Metrics** | What is broken? How bad? | Prometheus, Grafana, Datadog, CloudWatch |
| **Logs** | Why is it broken? What happened? | CloudWatch, Elasticsearch, Grafana Loki |
| **Traces** | Where in the call chain? | Datadog, Grafana Tempo |

Always start with metrics to scope the problem, then drill into logs for root cause.

## Investigation Framework: Detect, Triage, Investigate, Resolve

### Step 1: Detect - Confirm the Problem

Establish what is happening and when it started.

**Check error rates:**
```promql
rate(http_requests_total{status=~"5.."}[5m])
```

**Check latency:**
```promql
histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))
```

**Check Grafana alerts:**
Use `mcp__grafana__` tools to list active alerts and recent incidents.

**Check Datadog monitors:**
Use `mcp__datadog__` tools to search for triggered monitors.

### Step 2: Triage - Scope and Severity

Determine the blast radius and user impact.

- Which services are affected?
- Is it a total outage or degraded performance?
- How many users are impacted?
- When did it start? (Correlate with deployment timestamps)

**Check recent deployments:**
```
CloudWatch Logs Insights:
fields @timestamp, @message
| filter @message like /deploy/
| sort @timestamp desc
| limit 20
```

### Step 3: Investigate - Find Root Cause

#### Pattern: Latency Spike

1. Check p99 latency by endpoint:
```promql
histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, handler))
```

2. Check downstream dependency latency:
```promql
rate(upstream_request_duration_seconds_sum[5m]) / rate(upstream_request_duration_seconds_count[5m])
```

3. Search logs for slow queries or timeouts:
```
CloudWatch: fields @timestamp, @message | filter @message like /timeout|slow query/ | sort @timestamp desc
```

4. Check resource saturation (CPU, memory, connections):
```promql
sum by (instance) (rate(node_cpu_seconds_total{mode!="idle"}[5m]))
container_memory_usage_bytes / container_spec_memory_limit_bytes
```

#### Pattern: Error Rate Increase

1. Break down errors by status code and endpoint:
```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) by (handler, status)
```

2. Search logs for exception stack traces:
```
Elasticsearch: {"query": {"bool": {"must": [{"match": {"level": "ERROR"}}, {"range": {"@timestamp": {"gte": "now-1h"}}}]}}}
```

3. Check if errors correlate with a deployment or config change.

#### Pattern: Resource Exhaustion

1. Check CPU, memory, disk:
```promql
# CPU utilization
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory utilization
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Disk utilization
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100
```

2. Check for OOM kills in logs.
3. Check connection pool exhaustion or file descriptor limits.

#### Pattern: Dependency Failure

1. Check upstream service error rates and latency.
2. Check database connection metrics.
3. Check external API response codes.
4. Search logs for connection refused, DNS resolution failures, or certificate errors.

### Step 4: Correlate Across Sources

Build a timeline by combining data from multiple sources:

1. Query Prometheus for the exact time the metric anomaly started.
2. Search CloudWatch/Elasticsearch logs in that time window for errors.
3. Check Grafana dashboards for correlated signals across services.
4. Check Datadog traces for the affected request path.

### Step 5: Resolve and Document

- Identify immediate remediation (restart, rollback, scale up).
- Document the root cause and timeline.
- Identify monitoring gaps to address.

## Signal Correlation Best Practices

- **Time alignment:** Always use the same time window across sources.
- **Label consistency:** Use consistent service/pod/instance labels when correlating.
- **Start broad, narrow down:** Begin with service-level metrics, then drill into specific instances.
- **Check the change log:** Most incidents are caused by recent changes (deployments, config updates, infrastructure changes).
- **Multiple signals confirm:** Never conclude root cause from a single data point. Correlate at least two independent signals.

## Example Investigation Workflow

**Scenario:** API error rate jumped from 0.1% to 15% at 14:32 UTC.

1. **Prometheus:** `rate(http_requests_total{status="500"}[5m])` confirms spike at 14:32.
2. **Prometheus:** `rate(http_requests_total{status="500"}[5m])` broken down by handler shows `/api/orders` is the source.
3. **CloudWatch Logs:** Filter for ERROR in the orders service at 14:30-14:35 reveals "connection refused" to the payments service.
4. **Prometheus:** `up{job="payments-service"}` shows the payments service went down at 14:31.
5. **CloudWatch Logs:** Payments service logs show OOM kill at 14:31.
6. **Prometheus:** `container_memory_usage_bytes{pod=~"payments.*"}` shows memory climbing steadily for 2 hours before the kill.
7. **Root cause:** Memory leak in payments service caused OOM, which caused order API failures.
8. **Remediation:** Restart payments service, increase memory limit, investigate memory leak.
