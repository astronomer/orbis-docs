---
title: "Manual Prometheus diagnostics"
slug: manual-prometheus-diagnostics
description: "Collect the Prometheus queries used by Orbis reporting manually."
hide-nav-links: true
hide-feedback: true
---

# Manual Prometheus diagnostics

Use this guide to collect deployment metrics directly from Prometheus when Orbis isn't available, in air-gapped environments, or for quick spot-checks.

## Prerequisites

- You have access to the Prometheus user interface (UI) or Grafana on the Astro Private Cloud (APC) cluster.
- `kubectl` is configured with access to the cluster.

## Access Prometheus

Port-forward the Prometheus service:

```bash
kubectl port-forward svc/astronomer-prometheus 9090:9090 -n astronomer
```

Open `http://localhost:9090/graph` in a browser.

## Required information

Collect the following before running queries:

| Variable | How to find it | Example |
|---|---|---|
| `<namespace>` | Run `kubectl get ns` and identify the deployment namespace. | `astronomer-solar-nebula-1234` |
| `<release-name>` | Run `kubectl get pods -n <namespace>` and use the prefix before `-scheduler-*`. | `solar-nebula-1234` |
| Time range | The customer-reported issue window, or the preceding seven days. | `2026-03-28 00:00` to `2026-04-04 00:00` |
| Step interval | `5m` for ranges shorter than 24 hours, `15m` for 1 to 7 days, `1h` for longer. | `15m` |

## Query coverage

This page mirrors the Prometheus query families used by `orbis reporting`:

- Base reporting queries from `src/orbis/config/prometheus_queries.yaml`.
- APC 1.x component queries from `src/orbis/config/prometheus_queries_1x.yaml`.

Validated query groups:

- `scheduler`
- `total_task_success`
- `total_task_failure`
- `celery`
- `ke`
- `triggerer`
- `webserver`
- `dag_processor`
- `api_server`

Reporting executes the scheduler and task queries for all deployments. It then selects the executor-specific query family:

- Celery Executor: Celery worker metrics plus KubernetesPodOperator (KPO) pod metrics.
- Kubernetes executor: Kubernetes executor pod metrics.
- APC 1.x: triggerer and webserver component metrics.
- Airflow 3 on APC 1.x: Dag processor and API server component metrics.

## Queries by component

### Scheduler

CPU usage rate:

```promql
rate(container_cpu_usage_seconds_total{namespace="<namespace>", container="scheduler"}[5m])
```

Shows the five-minute CPU usage rate for the scheduler container.

Memory usage in GB:

```promql
max by (pod) (container_memory_working_set_bytes{namespace="<namespace>", container="scheduler"}) / (1024 * 1024 * 1024)
```

Shows the memory working set in GB for the scheduler, grouped by pod.

### Celery workers

These queries apply only to deployments that use the Celery Executor.

CPU usage rate:

```promql
rate(container_cpu_usage_seconds_total{namespace="<namespace>", container="worker", pod=~"<release-name>-worker-.*"}[5m])
```

Memory usage in GB:

```promql
max by (pod) (container_memory_working_set_bytes{namespace="<namespace>", container="worker", pod=~"<release-name>-worker-.*"}) / (1024 * 1024 * 1024)
```

Pod count:

```promql
count(kube_pod_info{namespace="<namespace>", pod=~"<release-name>-worker-.*"})
```

If reporting has worker queue metadata, it narrows the worker pod pattern from:

```promql
pod=~"<release-name>-worker-.*"
```

to:

```promql
pod=~"<release-name>-worker-<queue-name>-.*"
```

### Task metrics

Total successful task instances:

```promql
sum(airflow_ti_successes{release="<release-name>"})
```

Total failed task instances:

```promql
sum(airflow_ti_failures{release="<release-name>"})
```

Hourly task trend (success):

```promql
max(round(increase(airflow_ti_successes{release="<release-name>"}[1h])))
```

Hourly task trend (failure):

```promql
max(round(increase(airflow_ti_failures{release="<release-name>"}[1h])))
```

### KubernetesPodOperator and Kubernetes executor pods

These queries capture pods in the namespace that are not part of the Airflow release. Reporting uses this family for:

- KPO metrics when the deployment uses the Celery executor.
- Kubernetes executor metrics when the deployment uses the Kubernetes executor.

Reporting runs each pod query twice, once for small pods and once for large pods.

| Pod group | CPU condition | Memory condition | Boolean condition |
|---|---|---|---|
| Small | `> 0.25` | `> (500 * 1024 * 1024)` | `or` |
| Large | `<= 0.25` | `<= (500 * 1024 * 1024)` | `and` |

Small pods are the result left after excluding pods greater than either threshold. Large pods are the result left after excluding pods less than or equal to both thresholds.

CPU usage rate:

```promql
sum(
  max by (pod) (
    rate(container_cpu_usage_seconds_total{container!="", namespace="<namespace>", pod!~"<release-name>-.*"}[5m])
  )
  unless
  (
    (
      max by (pod) (rate(container_cpu_usage_seconds_total{container!="", namespace="<namespace>", pod!~"<release-name>-.*"}[5m])) <cpu-condition>
    )
    <boolean-condition>
    (
      max by (pod) (container_memory_working_set_bytes{container!="", namespace="<namespace>", pod!~"<release-name>-.*"}) <memory-condition>
    )
  )
)
```

Memory usage in GB:

```promql
sum(
  max by (pod) (
    container_memory_working_set_bytes{container!="", namespace="<namespace>", pod!~"<release-name>-.*"}
  ) / (1024 * 1024 * 1024)
  unless
  (
    (
      max by (pod) (rate(container_cpu_usage_seconds_total{container!="", namespace="<namespace>", pod!~"<release-name>-.*"}[5m])) <cpu-condition>
    )
    <boolean-condition>
    (
      max by (pod) (container_memory_working_set_bytes{container!="", namespace="<namespace>", pod!~"<release-name>-.*"}) <memory-condition>
    )
  )
)
```

Pod count:

```promql
count(
  max by (pod) (container_memory_working_set_bytes{container!="", namespace="<namespace>", pod!~"<release-name>-.*"})
  unless
  (
    (
      max by (pod) (rate(container_cpu_usage_seconds_total{container!="", namespace="<namespace>", pod!~"<release-name>-.*"}[5m])) <cpu-condition>
    )
    <boolean-condition>
    (
      max by (pod) (container_memory_working_set_bytes{container!="", namespace="<namespace>", pod!~"<release-name>-.*"}) <memory-condition>
    )
  )
)
```

For manual collection, replace the condition placeholders using the preceding pod group table.

### APC 1.x triggerer

CPU usage rate:

```promql
rate(container_cpu_usage_seconds_total{namespace="<namespace>", container="triggerer"}[5m])
```

Memory usage in GB:

```promql
max by (pod) (container_memory_working_set_bytes{namespace="<namespace>", container="triggerer"}) / (1024 * 1024 * 1024)
```

### APC 1.x webserver

CPU usage rate:

```promql
rate(container_cpu_usage_seconds_total{namespace="<namespace>", container="webserver"}[5m])
```

Memory usage in GB:

```promql
max by (pod) (container_memory_working_set_bytes{namespace="<namespace>", container="webserver"}) / (1024 * 1024 * 1024)
```

### Airflow 3 Dag processor

CPU usage rate:

```promql
rate(container_cpu_usage_seconds_total{namespace="<namespace>", container="dag-processor"}[5m])
```

Memory usage in GB:

```promql
max by (pod) (container_memory_working_set_bytes{namespace="<namespace>", container="dag-processor"}) / (1024 * 1024 * 1024)
```

### Airflow 3 API server

CPU usage rate:

```promql
rate(container_cpu_usage_seconds_total{namespace="<namespace>", container="api-server"}[5m])
```

Memory usage in GB:

```promql
max by (pod) (container_memory_working_set_bytes{namespace="<namespace>", container="api-server"}) / (1024 * 1024 * 1024)
```

## Collect data from Prometheus

1. Open `http://localhost:9090/graph` after port-forwarding.
2. Select **Graph**.
3. Paste a query from the preceding sections into the query input field. Replace `<namespace>` and `<release-name>` with the actual values.
4. Set the time range using the start and end time fields.
5. Set the resolution step, for example `15m`.
6. Click **Execute**.
7. Verify that data appears in the graph.

## Capture images

Each image must include:

- The full query visible in the query input field.
- The time range selector showing the start and end dates.
- The graph or table with data visible.

Use this naming convention: `<namespace>_<metric-name>_<date-range>.png`.

Examples:

- `astronomer-solar-nebula-1234_scheduler_cpu_2026-03-28_to_2026-04-04.png`
- `astronomer-solar-nebula-1234_celery_memory_2026-03-28_to_2026-04-04.png`

## Collect data from Grafana

If Grafana is available instead of the Prometheus UI directly:

1. Open the Airflow dashboard or create a new panel.
2. Use the same PromQL queries listed in the preceding sections.
3. Set the time picker to the required range.
4. Use the panel share or export feature to save images.

## Package results

1. Create a folder:

    ```bash
    mkdir manual-diagnostics-<namespace>-<date>
    ```

2. Move all images into the folder. Include a text file that lists the namespace, release name, time range, and cluster context.

3. Compress the folder:

    ```bash
    tar -czf manual-diagnostics-<namespace>-<date>.tar.gz manual-diagnostics-<namespace>-<date>/
    ```

4. Share the archive with [Astronomer support](https://support.astronomer.io).
