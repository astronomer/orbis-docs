# CSV Generator

The CSV Generator module is responsible for creating a CSV report from the overall deployment compute data. It provides functions to process and format the data according to a predefined CSV template.

## Main Functions

### generate_csv_from_report

This function is the entry point for CSV generation. It takes an `OverallReport` object and a file path, then writes the formatted data to a CSV file.

### process_namespace_report

Processes a single `NamespaceReport` and returns a list of dictionaries representing rows in the CSV file. It handles different executor types (Kubernetes and Celery) and their specific metrics.

## Helper Functions

- `create_base_row`: Creates a base dictionary with common deployment information.
- `update_scheduler_metrics`: Updates the row with scheduler-specific metrics.
- `update_kubernetes_worker_metrics`: Adds Kubernetes worker metrics to the row.
- `update_celery_cpu_metrics`: Processes Celery CPU metrics for each worker queue.
- `update_celery_memory_metrics`: Adds Celery memory metrics for each worker queue.
- `update_celery_kpo_metrics`: Handles Celery KPO (Kubernetes Pod Operator) specific metrics.

## Data Processing

The module handles different executor types (Kubernetes and Celery) and their specific metrics. For Celery executors, it creates separate rows for each worker queue and an additional row for KPO metrics if applicable.

## CSV Structure

The CSV file follows a predefined template structure, which includes:
- Deployment information (name, namespace, executor type)
- Scheduler metrics
- Worker metrics (type, queue name, concurrency, etc.)
- CPU and memory statistics for both scheduler and workers

This module ensures that the complex deployment data is formatted into a clear, tabular format for easy analysis and reporting.
