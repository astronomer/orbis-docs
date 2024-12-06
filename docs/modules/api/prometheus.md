# Prometheus Data Fetching

The `PrometheusData` class in `prometheus.py` is crucial for populating the metric models with real-time data from Prometheus. It provides an efficient and robust mechanism for fetching large amounts of data over extended time periods.

## Key Features

1. **Asynchronous Data Fetching**: Utilizes `asyncio` for non-blocking API calls, improving performance.
2. **Batched Queries**: Implements a batching mechanism to handle large date ranges without overwhelming the Prometheus API or client.
3. **Error Handling**: Robust error handling for API failures and data inconsistencies.
4. **Data Processing**: Converts raw API responses into Polars DataFrames for efficient data manipulation.

## Data Fetching Mechanism

The `query_over_range` method implements a sophisticated batching strategy:

1. **Time Period Division**: The total query time range is divided into smaller periods (default 6 hours).
2. **Parallel Queries**: Multiple queries are executed in parallel for each time period.
3. **Data Aggregation**: Results from all periods are combined into a single DataFrame.
4. **Data Cleaning**: Duplicate timestamps are removed, and values are sorted and cast to the appropriate data type.

This approach allows Orbis to fetch and process data for extended time ranges that would typically cause issues in the Prometheus web UI.

## Populating Models

The `PrometheusData` class doesn't directly populate the models but provides the raw data needed:

1. The `query_over_range` method returns a Polars DataFrame with timestamp and value columns.
2. This DataFrame is then used in `generator.py` to create `Figure` objects and calculate metrics.
3. The calculated metrics are used to populate `MetricCalculation` and `NamespaceReport` objects.

## Extensibility

Adding new metrics or modifying existing ones primarily involves:

1. Updating the query strings passed to `query_over_range`.
2. Adjusting the data processing logic in `generator.py` if the new metric requires special handling.

The `PrometheusData` class itself rarely needs modification when adding new metrics, making it a stable foundation for Orbis's data fetching needs.

## Queries

The `PrometheusData` class uses a list of queries to fetch data from the Prometheus API. These queries are divided into batches and executed in parallel to improve performance.

## Prometheus Queries

This document details all the Prometheus queries used by Orbis to collect metrics.

```promql
# Scheduler CPU usage rate over 5-minute intervals
rate(container_cpu_usage_seconds_total{namespace="astronomer-optical-illusion-5432", container="scheduler"}[5m])

# Scheduler memory usage in gigabytes
max(container_memory_working_set_bytes{namespace="astronomer-optical-illusion-5432", container="scheduler"}) by (pod)
/(1024 * 1024 *1024)

# Total count of successful task instances
sum(airflow_ti_successes{release="optical-illusion-5432"})

# Total count of failed task instances
sum(airflow_ti_failures{release="optical-illusion-5432"})

# Hourly increase in successful tasks
max(round(increase(airflow_ti_successes{release="optical-illusion-5432"}[1h])))

# Hourly increase in failed tasks
max(round(increase(airflow_ti_failures{release="optical-illusion-5432"}[1h])))

# Celery workers CPU usage rate over 5-minute intervals
rate(container_cpu_usage_seconds_total{namespace="astronomer-optical-illusion-5432", container="worker", pod=~"astronomer-optical-illusion-5432-worker-.*"}[5m])

# Celery workers memory usage in gigabytes
max(container_memory_working_set_bytes{namespace="astronomer-optical-illusion-5432", container="worker", pod=~"astronomer-optical-illusion-5432-worker-.*"}) by (pod)
/(1024 * 1024 *1024)

# Count of Celery worker pods
count(kube_pod_info{namespace="astronomer-optical-illusion-5432", pod=~"astronomer-optical-illusion-5432-worker-.*"})

# Kubernetes Pod Operator CPU usage
sum(
  kube_pod_labels{label_airflow_kpo_in_cluster="True",namespace="astronomer-optical-illusion-5432"}
  * on (pod) group_left()
  sum by (pod) (
    rate(container_cpu_usage_seconds_total{namespace="astronomer-optical-illusion-5432",pod!~"astronomer-optical-illusion-5432-.*"}[5m])
  )
)

# Kubernetes Pod Operator memory usage in gigabytes
sum(
  kube_pod_labels{label_airflow_kpo_in_cluster="True",namespace="astronomer-optical-illusion-5432"}
  * on (pod) group_left()
  max by (pod) (
    container_memory_working_set_bytes{namespace="astronomer-optical-illusion-5432",pod!~"astronomer-optical-illusion-5432-.*"}
  )
)/(1024 * 1024 *1024)
```

## Metric Aggregation

For each metric, we calculate the following aggregations:

- Minimum value
- Maximum value
- Mean value
- Median value

These aggregations help provide a comprehensive view of the metric's behavior over time.