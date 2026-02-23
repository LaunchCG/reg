---
name: promql-guide
description: PromQL query patterns for common monitoring scenarios including RED and USE methods
allowed-tools: mcp__prometheus__*
mcpServers:
  - prometheus
---

# PromQL Guide

Reference guide for writing PromQL queries to analyze Prometheus metrics, covering syntax fundamentals, common patterns, and monitoring methodologies.

## When This Skill is Invoked

This skill will be used when you mention:
- "PromQL" or "Prometheus query"
- "RED method" or "USE method"
- "metrics query"
- "rate of requests"
- "error rate" or "latency percentile"
- "SLO" or "SLI"

## PromQL Fundamentals

### Data Types

- **Instant vector:** A set of time series with a single sample per series at a point in time.
- **Range vector:** A set of time series with a range of samples over time, specified with `[duration]`.
- **Scalar:** A single numeric value.

### Selectors and Label Matchers

```promql
# Exact match
http_requests_total{method="GET"}

# Regex match
http_requests_total{status=~"5.."}

# Negative match
http_requests_total{method!="OPTIONS"}

# Negative regex
http_requests_total{status!~"2.."}
```

### Range Vector Durations

Common durations: `[1m]`, `[5m]`, `[15m]`, `[1h]`, `[1d]`

Rule of thumb: Use `[5m]` for real-time dashboards, `[15m]` or `[1h]` for smoother trends.

## Essential Functions

### rate() - Per-second rate of increase

```promql
# Request rate over 5 minutes
rate(http_requests_total[5m])

# ALWAYS use rate() with counters. Never graph a raw counter.
```

### increase() - Total increase over a range

```promql
# Total requests in the last hour
increase(http_requests_total[1h])
```

### histogram_quantile() - Percentile from histograms

```promql
# p99 latency
histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))

# p50 latency by handler
histogram_quantile(0.50, sum by (le, handler) (rate(http_request_duration_seconds_bucket[5m])))
```

### Aggregation operators

```promql
# Sum across all instances
sum(rate(http_requests_total[5m]))

# Average by service
avg by (service) (rate(http_requests_total[5m]))

# Top 5 by request rate
topk(5, sum by (handler) (rate(http_requests_total[5m])))

# Count of series
count by (status) (http_requests_total)
```

## RED Method (Request-Driven Services)

The RED method monitors the three key signals for request-driven services.

### Rate - Requests per second

```promql
# Total request rate
sum(rate(http_requests_total[5m]))

# Request rate by endpoint
sum by (handler) (rate(http_requests_total[5m]))

# Request rate by status class
sum by (status) (rate(http_requests_total[5m]))
```

### Errors - Failed requests per second

```promql
# Error rate (5xx responses)
sum(rate(http_requests_total{status=~"5.."}[5m]))

# Error ratio (percentage of requests that are errors)
sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100

# Error ratio by endpoint
sum by (handler) (rate(http_requests_total{status=~"5.."}[5m])) / sum by (handler) (rate(http_requests_total[5m])) * 100
```

### Duration - Latency distribution

```promql
# p50 latency (median)
histogram_quantile(0.50, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))

# p95 latency
histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))

# p99 latency
histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))

# Average latency
sum(rate(http_request_duration_seconds_sum[5m])) / sum(rate(http_request_duration_seconds_count[5m]))
```

## USE Method (Infrastructure Resources)

The USE method monitors resources like CPU, memory, disk, and network.

### Utilization - Percentage of resource in use

```promql
# CPU utilization (percentage)
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory utilization
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Disk utilization
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100
```

### Saturation - Amount of queued or excess work

```promql
# CPU saturation (load average vs CPU count)
node_load1 / count without (cpu, mode) (node_cpu_seconds_total{mode="idle"})

# Memory saturation (swap usage)
node_memory_SwapTotal_bytes - node_memory_SwapFree_bytes

# Disk I/O saturation (average queue size)
rate(node_disk_io_time_weighted_seconds_total[5m])
```

### Errors - Resource error counts

```promql
# Network errors
rate(node_network_receive_errs_total[5m]) + rate(node_network_transmit_errs_total[5m])

# Disk errors
rate(node_disk_io_errors_total[5m])
```

## SLO-Based Queries

### Error Budget

```promql
# SLO: 99.9% availability
# Error budget remaining (fraction of error budget over 30 days)
1 - (
  sum(increase(http_requests_total{status=~"5.."}[30d]))
  /
  sum(increase(http_requests_total[30d]))
) / (1 - 0.999)
```

### Burn Rate

```promql
# 1-hour burn rate (how fast are we consuming error budget)
(
  sum(rate(http_requests_total{status=~"5.."}[1h]))
  /
  sum(rate(http_requests_total[1h]))
) / (1 - 0.999)
```

### Latency SLO

```promql
# Percentage of requests under 250ms SLO
sum(rate(http_request_duration_seconds_bucket{le="0.25"}[5m]))
/
sum(rate(http_request_duration_seconds_count[5m])) * 100
```

## Container and Kubernetes Queries

```promql
# Pod CPU usage
sum by (pod) (rate(container_cpu_usage_seconds_total[5m]))

# Pod memory usage
sum by (pod) (container_memory_usage_bytes{container!=""})

# Pod restarts
sum by (pod) (increase(kube_pod_container_status_restarts_total[1h]))

# Container OOM kills
increase(container_oom_events_total[1h])

# Pods not ready
kube_pod_status_ready{condition="false"}
```

## Anti-Patterns to Avoid

### Missing rate() on counters
```promql
# BAD: Raw counter always increases
http_requests_total

# GOOD: Per-second rate
rate(http_requests_total[5m])
```

### High cardinality label selectors
```promql
# BAD: user_id label creates millions of series
rate(http_requests_total{user_id=~".+"}[5m])

# GOOD: Aggregate away high-cardinality labels
sum by (handler, status) (rate(http_requests_total[5m]))
```

### Range too short for scrape interval
```promql
# BAD: 1m range with 30s scrape interval may miss samples
rate(http_requests_total[1m])

# GOOD: At least 4x the scrape interval
rate(http_requests_total[5m])
```

### Using avg for latency (hides tail latency)
```promql
# BAD: Average hides the slow requests
avg(http_request_duration_seconds)

# GOOD: Use percentiles to see the distribution
histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))
```

## Quick Reference

| Goal | Query Pattern |
|------|--------------|
| Request rate | `sum(rate(http_requests_total[5m]))` |
| Error rate % | `sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) * 100` |
| p99 latency | `histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))` |
| CPU usage | `100 - avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m]) * 100)` |
| Memory usage | `(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100` |
| Pod restarts | `increase(kube_pod_container_status_restarts_total[1h])` |
| Top endpoints | `topk(5, sum by (handler) (rate(http_requests_total[5m])))` |
