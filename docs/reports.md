# Orbis Reports

Orbis generates comprehensive deployment compute reports that provide detailed insights into your Astronomer Software deployments.

## Report Components

### 1. Word Document Report

The main report is generated as a Word document containing:

- Title page with report metadata
- Detailed deployment information
- Statistical analysis and metrics
- Visualization charts and graphs
- Query URLs for reference

### 2. CSV Report

A detailed CSV report containing:

- Deployment information (name, namespace, executor type)
- Scheduler metrics
- Worker metrics (type, queue name, concurrency)
- CPU and memory statistics
- KPO (Kubernetes Pod Operator) metrics where applicable

### 3. Data Visualizations

Interactive graphs and charts showing:

- Resource utilization trends
- Performance metrics over time
- Statistical measures (mean, median)
- Adaptive downsampling for large datasets

## Report Generation Process

1. Data Collection:
    - Fetches metrics from Prometheus
    - Gathers deployment information via Houston API
    - Collects resource utilization data

2. Data Processing:
    - Applies adaptive downsampling for large datasets
    - Calculates statistical measures
    - Processes metrics based on executor type

3. Visualization:
    - Generates interactive Plotly graphs
    - Creates separate folders for organizations
    - Customizes layouts for optimal readability

4. Report Compilation:
    - Generates Word document with formatted content
    - Creates CSV export with detailed metrics
    - Organizes visualizations and data

## Output Formats

- Word Document (.docx): Main report with visualizations
- CSV File: Detailed metric data in tabular format
- JSON Data: Raw report data for further processing
- Shareable via pre-signed URL (when using `-p` flag)
- Combined ZIP archive (when using `-z` flag)

## Accessing Reports

Reports are generated in the `output` directory when using Docker:
```bash
docker run --rm -it \
  --env-file .env \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:0.6.1 orbis compute-software \
  -s START_DATE -e END_DATE -o ORGANIZATION_ID
```
