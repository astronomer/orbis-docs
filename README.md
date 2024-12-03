# Orbis Documentation
<div style="text-align:center">
   <img src="../docs/assets/orbis_logo.svg" width="50%" alt="Orbis Logo">
</div>

Orbis is a reporting tool designed for Astronomer Software that provides detailed insights into your Apache Airflow deployments. It collects and analyzes metrics to help you understand resource utilization, performance patterns, and system health.

## Key Features

- **Resource Metrics**: Track CPU usage, memory consumption, and resource allocation efficiency
- **Performance Analysis**: Monitor task success/failure rates, processing trends, and execution latency
- **System Health**: Get insights into scheduler health, worker status, and system availability
- **Comprehensive Reports**: Generate detailed PDF reports with visualizations and statistics

## Quick Start

```bash
# Pull the latest version
docker pull quay.io/astronomer/orbis:0.5.0

# Run with environment variables
docker run --pull always --rm -it \
  --env-file .env \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:0.5.0 orbis compute-software \
  -s START_DATE \
  -e END_DATE \
  -o ORGANIZATION_ID
```

## Documentation

The documentation covers:
- Installation Guide
- Usage Instructions
- API Documentation

## Support

If you encounter any issues, please:
1. Check the documentation in this repository
2. Create a new issue using our issue templates

## License

Copyright (c) 2021 Astronomer, LLC
