---
name: log-analysis
description: Log query patterns for CloudWatch Logs Insights, Elasticsearch, and Grafana Loki
allowed-tools: mcp__cloudwatch__*, mcp__elasticsearch__*, mcp__grafana__*
mcpServers:
  - cloudwatch
  - elasticsearch
  - grafana
---

# Log Analysis Skill

Query patterns and techniques for analyzing logs across CloudWatch Logs Insights, Elasticsearch, and Grafana Loki to diagnose issues and understand system behavior.

## When This Skill is Invoked

This skill will be used when you mention:
- "search logs" or "log analysis"
- "CloudWatch Logs" or "Log Insights"
- "Elasticsearch query" or "Kibana"
- "Loki" or "LogQL"
- "find errors in logs"
- "log patterns"

## CloudWatch Logs Insights

### Syntax Basics

CloudWatch Logs Insights uses a pipe-delimited query language.

**Core commands:**
- `fields` - Select fields to display
- `filter` - Filter log events
- `stats` - Aggregate statistics
- `sort` - Order results
- `parse` - Extract fields from unstructured logs
- `limit` - Cap result count

### Common Queries

**Find recent errors:**
```
fields @timestamp, @message
| filter @message like /ERROR|Exception|FATAL/
| sort @timestamp desc
| limit 50
```

**Count errors by type:**
```
fields @message
| filter @message like /ERROR/
| parse @message "ERROR * - *" as errorType, errorMessage
| stats count(*) by errorType
| sort count(*) desc
```

**Latency percentiles from structured logs:**
```
filter ispresent(duration)
| stats avg(duration) as avgLatency,
        pct(duration, 50) as p50,
        pct(duration, 95) as p95,
        pct(duration, 99) as p99
  by bin(5m)
```

**Request volume over time:**
```
filter @message like /POST|GET|PUT|DELETE/
| stats count(*) as requestCount by bin(5m)
| sort bin asc
```

**Find slow requests:**
```
filter duration > 5000
| fields @timestamp, handler, duration, statusCode
| sort duration desc
| limit 20
```

**Parse unstructured log lines:**
```
parse @message "[*] * * *: *" as timestamp, level, thread, logger, message
| filter level = "ERROR"
| stats count(*) by logger
| sort count(*) desc
```

**Trace a specific request by ID:**
```
filter requestId = "abc-123-def-456"
| fields @timestamp, @message
| sort @timestamp asc
```

**Find deployment events:**
```
fields @timestamp, @message
| filter @message like /deploy|release|rollback|startup|shutdown/
| sort @timestamp desc
| limit 20
```

## Elasticsearch Query DSL

### Common Query Patterns

**Match errors in the last hour:**
```json
{
  "query": {
    "bool": {
      "must": [
        { "match": { "level": "ERROR" } },
        { "range": { "@timestamp": { "gte": "now-1h" } } }
      ]
    }
  },
  "sort": [{ "@timestamp": { "order": "desc" } }],
  "size": 50
}
```

**Full-text search across messages:**
```json
{
  "query": {
    "bool": {
      "must": [
        { "match_phrase": { "message": "connection refused" } },
        { "range": { "@timestamp": { "gte": "now-6h" } } }
      ]
    }
  }
}
```

**Aggregate error counts by service:**
```json
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        { "match": { "level": "ERROR" } },
        { "range": { "@timestamp": { "gte": "now-1h" } } }
      ]
    }
  },
  "aggs": {
    "by_service": {
      "terms": { "field": "service.keyword", "size": 20 },
      "aggs": {
        "by_error": {
          "terms": { "field": "error.type.keyword", "size": 10 }
        }
      }
    }
  }
}
```

**Histogram of errors over time:**
```json
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        { "match": { "level": "ERROR" } },
        { "range": { "@timestamp": { "gte": "now-24h" } } }
      ]
    }
  },
  "aggs": {
    "errors_over_time": {
      "date_histogram": {
        "field": "@timestamp",
        "fixed_interval": "15m"
      }
    }
  }
}
```

**Latency percentiles from log data:**
```json
{
  "size": 0,
  "query": {
    "range": { "@timestamp": { "gte": "now-1h" } }
  },
  "aggs": {
    "latency_percentiles": {
      "percentiles": {
        "field": "response_time_ms",
        "percents": [50, 75, 90, 95, 99]
      }
    }
  }
}
```

**Find unique error messages (cardinality):**
```json
{
  "size": 0,
  "query": {
    "bool": {
      "must": [
        { "match": { "level": "ERROR" } },
        { "range": { "@timestamp": { "gte": "now-1h" } } }
      ]
    }
  },
  "aggs": {
    "unique_errors": {
      "cardinality": { "field": "error.message.keyword" }
    },
    "top_errors": {
      "terms": { "field": "error.message.keyword", "size": 10 }
    }
  }
}
```

## Log Analysis Patterns

### Error Clustering

Group similar errors to identify the most impactful issues:

1. Query for all errors in the time window.
2. Aggregate by error type or message pattern.
3. Sort by count descending.
4. Focus investigation on the top 2-3 error clusters.

### Correlation with Metrics

When a metric anomaly is detected:

1. Note the exact timestamp of the anomaly from Prometheus/Grafana.
2. Query logs in a window of 5 minutes before to 5 minutes after.
3. Filter for the affected service/component.
4. Look for errors, warnings, or unusual patterns.

### Request Tracing Through Logs

Follow a single request across services:

1. Identify the request ID or correlation ID.
2. Search all log groups/indices for that ID.
3. Sort by timestamp ascending to see the request flow.
4. Identify where the request failed or slowed down.

### Structured vs Unstructured Logs

**Structured logs** (JSON format) allow direct field queries:
```
filter level = "ERROR" and service = "payments"
```

**Unstructured logs** require parsing:
```
parse @message "[*] [*] *" as timestamp, level, message
| filter level = "ERROR"
```

Always prefer structured log queries when available -- they are faster and more reliable.

### Identifying Patterns in Noise

When investigating a high-volume log stream:

1. **Exclude known noise:** Filter out health checks, routine messages.
2. **Group by unique patterns:** Use `stats count(*) by` to find clusters.
3. **Focus on new patterns:** Compare with a known-good baseline time window.
4. **Check rate of change:** A pattern that suddenly increases is more interesting than a steady one.

## Quick Reference

| Goal | CloudWatch Logs Insights | Elasticsearch |
|------|-------------------------|---------------|
| Recent errors | `filter @message like /ERROR/ \| sort @timestamp desc` | `{"query":{"match":{"level":"ERROR"}}}` |
| Count by type | `stats count(*) by errorType` | `{"aggs":{"by_type":{"terms":{"field":"type.keyword"}}}}` |
| Time histogram | `stats count(*) by bin(5m)` | `{"aggs":{"over_time":{"date_histogram":{"field":"@timestamp","fixed_interval":"5m"}}}}` |
| Text search | `filter @message like /pattern/` | `{"query":{"match_phrase":{"message":"pattern"}}}` |
| Field extraction | `parse @message "* *" as a, b` | Use ingest pipelines or runtime fields |
| Top N | `sort count(*) desc \| limit 10` | `{"aggs":{"top":{"terms":{"field":"f.keyword","size":10}}}}` |
