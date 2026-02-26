<!-- dex:app-instrumentation -->
---
name: app-instrumentation
description: OTEL instrumentation patterns for Python/FastAPI and Node.js to publish traces, metrics, and logs to the local telemetry stack or any OTLP backend
---

# App Instrumentation with OpenTelemetry

You know how to instrument Python/FastAPI and Node.js applications with OpenTelemetry to emit traces, metrics, and logs via OTLP to the local telemetry stack or any OTLP-compatible backend.

## When to Use This Skill

Use when:
- Adding observability to a Python or Node.js service
- Setting up OTEL tracing, metrics, or logging for the first time
- Connecting an app to the local telemetry stack
- Debugging missing telemetry signals

## Required Environment Variables

All OTEL SDKs read configuration from environment variables:

```bash
# Endpoint (gRPC preferred for local stack)
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
OTEL_EXPORTER_OTLP_PROTOCOL=grpc

# Service identity
OTEL_SERVICE_NAME=my-service
OTEL_RESOURCE_ATTRIBUTES=service.version=1.0.0,deployment.environment=local
```

For containerized apps on the `nexus-telemetry-network`, use:
```bash
OTEL_EXPORTER_OTLP_ENDPOINT=http://nexus-otel-collector:4317
```

For containerized apps **not** on the telemetry network (e.g., your own docker-compose with its own network bridge), reach the collector on the host:
```bash
OTEL_EXPORTER_OTLP_ENDPOINT=http://host.docker.internal:4317
```

> `host.docker.internal` resolves to the Docker host on Mac and Windows. On Linux, add `--add-host=host.docker.internal:host-gateway` to your container or set `extra_hosts: ["host.docker.internal:host-gateway"]` in docker-compose.

---

## Python / FastAPI

### Dependencies (`pyproject.toml`)

```toml
[project.dependencies]
opentelemetry-sdk = ">=1.23.0"
opentelemetry-exporter-otlp-proto-grpc = ">=1.23.0"
opentelemetry-instrumentation-fastapi = ">=0.44b0"
opentelemetry-instrumentation-httpx = ">=0.44b0"
opentelemetry-instrumentation-logging = ">=0.44b0"
# Add if using SQLAlchemy:
# opentelemetry-instrumentation-sqlalchemy = ">=0.44b0"
```

### `telemetry.py` — SDK initialization

```python
import logging
from opentelemetry import trace, metrics
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.sdk.resources import Resource, SERVICE_NAME, SERVICE_VERSION
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
from opentelemetry.sdk._logs import LoggerProvider, LoggingHandler
from opentelemetry.sdk._logs.export import BatchLogRecordProcessor
from opentelemetry.exporter.otlp.proto.grpc._log_exporter import OTLPLogExporter
from opentelemetry._logs import set_logger_provider


def configure_telemetry(service_name: str, service_version: str = "0.0.0") -> None:
    resource = Resource.create({
        SERVICE_NAME: service_name,
        SERVICE_VERSION: service_version,
    })

    # Traces
    tracer_provider = TracerProvider(resource=resource)
    tracer_provider.add_span_processor(BatchSpanProcessor(OTLPSpanExporter()))
    trace.set_tracer_provider(tracer_provider)

    # Metrics
    reader = PeriodicExportingMetricReader(OTLPMetricExporter(), export_interval_millis=15000)
    metrics.set_meter_provider(MeterProvider(resource=resource, metric_readers=[reader]))

    # Logs — bridge Python logging into OTEL
    logger_provider = LoggerProvider(resource=resource)
    logger_provider.add_log_record_processor(BatchLogRecordProcessor(OTLPLogExporter()))
    set_logger_provider(logger_provider)
    logging.getLogger().addHandler(LoggingHandler(logger_provider=logger_provider))
```

### `main.py` — FastAPI integration

```python
import os
from fastapi import FastAPI
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.httpx import HTTPXClientInstrumentor
from .telemetry import configure_telemetry

configure_telemetry(
    service_name=os.getenv("OTEL_SERVICE_NAME", "my-api"),
    service_version=os.getenv("SERVICE_VERSION", "0.0.0"),
)

app = FastAPI()
FastAPIInstrumentor.instrument_app(app)
HTTPXClientInstrumentor().instrument()
```

### Custom spans and metrics

```python
from opentelemetry import trace, metrics

tracer = trace.get_tracer(__name__)
meter = metrics.get_meter(__name__)
request_counter = meter.create_counter("my_api.requests", unit="1")

async def process_order(order: OrderRequest):
    with tracer.start_as_current_span("process_order") as span:
        span.set_attribute("order.customer_id", order.customer_id)
        request_counter.add(1, {"endpoint": "/orders"})
        result = await do_work(order)
        span.set_attribute("order.id", result.id)
        return result
```

---

## Node.js

### Dependencies (`package.json`)

```json
{
  "dependencies": {
    "@opentelemetry/sdk-node": "^0.49.0",
    "@opentelemetry/exporter-trace-otlp-grpc": "^0.49.0",
    "@opentelemetry/exporter-metrics-otlp-grpc": "^0.49.0",
    "@opentelemetry/sdk-metrics": "^1.22.0",
    "@opentelemetry/instrumentation-http": "^0.49.0",
    "@opentelemetry/instrumentation-express": "^0.38.0",
    "@opentelemetry/resources": "^1.22.0",
    "@opentelemetry/semantic-conventions": "^1.22.0"
  }
}
```

### `tracing.js` — SDK initialization

```javascript
// Require BEFORE any other imports: node -r ./tracing.js index.js
const { NodeSDK } = require('@opentelemetry/sdk-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc');
const { OTLPMetricExporter } = require('@opentelemetry/exporter-metrics-otlp-grpc');
const { PeriodicExportingMetricReader } = require('@opentelemetry/sdk-metrics');
const { HttpInstrumentation } = require('@opentelemetry/instrumentation-http');
const { ExpressInstrumentation } = require('@opentelemetry/instrumentation-express');
const { Resource } = require('@opentelemetry/resources');
const { ATTR_SERVICE_NAME, ATTR_SERVICE_VERSION } = require('@opentelemetry/semantic-conventions');

const sdk = new NodeSDK({
  resource: new Resource({
    [ATTR_SERVICE_NAME]: process.env.OTEL_SERVICE_NAME || 'my-node-service',
    [ATTR_SERVICE_VERSION]: process.env.SERVICE_VERSION || '0.0.0',
    'deployment.environment': process.env.NODE_ENV || 'local',
  }),
  traceExporter: new OTLPTraceExporter(),
  metricReader: new PeriodicExportingMetricReader({
    exporter: new OTLPMetricExporter(),
    exportIntervalMillis: 15000,
  }),
  instrumentations: [new HttpInstrumentation(), new ExpressInstrumentation()],
});

sdk.start();
process.on('SIGTERM', () => sdk.shutdown().then(() => process.exit(0)));
```

### Custom spans

```javascript
const { trace, metrics, SpanStatusCode } = require('@opentelemetry/api');

const tracer = trace.getTracer('my-service');
const meter = metrics.getMeter('my-service');
const requestCounter = meter.createCounter('my_service.requests');

async function processOrder(order) {
  return tracer.startActiveSpan('process_order', async (span) => {
    try {
      span.setAttribute('order.customer_id', order.customerId);
      requestCounter.add(1, { operation: 'process_order' });
      const result = await doWork(order);
      span.setStatus({ code: SpanStatusCode.OK });
      return result;
    } catch (err) {
      span.recordException(err);
      span.setStatus({ code: SpanStatusCode.ERROR, message: err.message });
      throw err;
    } finally {
      span.end();
    }
  });
}
```

---

## Docker Compose Integration

Add to your app's `docker-compose.yml` to join the telemetry network:

```yaml
networks:
  app-network:
    driver: bridge
  nexus-telemetry:
    external: true
    name: nexus-telemetry-network

services:
  api:
    build: .
    environment:
      OTEL_EXPORTER_OTLP_ENDPOINT: http://nexus-otel-collector:4317
      OTEL_EXPORTER_OTLP_PROTOCOL: grpc
      OTEL_SERVICE_NAME: my-api
      OTEL_RESOURCE_ATTRIBUTES: service.version=1.0.0
    networks:
      - app-network
      - nexus-telemetry
```

## Verifying Instrumentation

1. Start the stack (`start-stack` runbook task).
2. Run your app with OTEL env vars set.
3. Send a few requests.
4. Check `http://localhost:8889/metrics` — your app's metrics should appear there.
5. In Grafana (http://localhost:3000), go to Explore → Loki → query `{service_name="my-service"}`.
6. Check traces in Elasticsearch index `otel-traces` via the `elasticsearch` MCP server.

## Common Issues

**No metrics in Prometheus:** Metrics flow through the OTEL Collector's Prometheus exporter on port 8889, not directly to Prometheus. Check http://localhost:8889/metrics first.

**gRPC connection refused:** Use `http://` not `https://` — the local stack uses plaintext gRPC.

**Python spans dropped on process exit:** Call `tracer_provider.shutdown()` in a shutdown hook or use a lifespan context manager in FastAPI.

**Node.js SDK not initialized before auto-instrumented libraries import:** `tracing.js` must be the first thing loaded. Use `-r ./tracing.js` or `--require ./tracing.js` in your start command, or set `NODE_OPTIONS=--require ./tracing.js`.

<!-- /dex:app-instrumentation -->
