# Prometheus Integration

The Prometheus integration in Orbis is used to collect metrics from Astronomer Software deployments. It provides detailed insights into resource utilization and performance metrics.

## Key Features

### Metric Collection

The Prometheus integration collects:

- CPU utilization
- Memory usage
- Task execution metrics
- Queue length and processing rates
- Worker performance statistics


## Core Components

### Prometheus Client

The Prometheus client handles:

- Connection to Prometheus endpoints
- Query execution and data retrieval
- Response parsing and formatting
- Error handling and retries

### Metric Types

1. Resource Metrics:

    - Container CPU usage
    - Container memory working set
    - Resource allocation efficiency

2. Performance Metrics:

    - Task success/failure counts
    - Task processing trends
    - Queue processing rates
    - Task execution latency

3. System Metrics:

    - Scheduler health metrics
    - Worker node status
    - System availability

## Data Processing

### Time Series Analysis

- Metric aggregation over time periods
- Statistical analysis of performance data
- Trend identification and reporting
- Anomaly detection capabilities

### Resource Utilization

- Comparison of allocated vs used resources
- Peak usage identification
- Resource mean and median utilization

## Configuration

### Example Queries

Here are some examples of PromQL queries used to collect metrics:
```promql
# CPU usage metrics
rate(container_cpu_usage_seconds_total{namespace="$namespace", container="scheduler"}[5m])

# Memory usage metrics
max(container_memory_working_set_bytes{namespace="$namespace", container="scheduler"}) by (pod)

# Task success metrics
sum(airflow_ti_successes{release="$release"})

# Task processing trend
max(round(increase(airflow_ti_successes{release="$release"}[1h])))
```

If using verbisity flags, you can find the queries in the log file generated in the `output` directory.

### Time Ranges

Metrics are collected over specific time ranges to provide:

- Historical data analysis
- Performance trends
- Resource utilization patterns
- System health monitoring
