# Orbis Documentation
<div style="text-align:center">
   <img src="docs/assets/orbis_logo.svg" width="50%" alt="Orbis Logo">
</div>

Orbis is a comprehensive toolkit designed for Astronomer Software that provides deployment reporting and diagnostic capabilities for your Apache Airflow deployments.

## Key Features

We currently support 2 main capabilities (with more coming in future releases):

1. **Report Generation**: Comprehensive deployment metrics analysis including CPU usage, memory consumption, resource allocation efficiency, task success/failure rates, processing trends, and execution latency
2. **Diagnostic Scanner**: Creates comprehensive support bundles containing Kubernetes cluster information, Astronomer deployment details, logs, and configurations for accelerated troubleshooting

## Quick Start

### Report Generation
```bash
# Pull the latest version
docker pull quay.io/astronomer/orbis:0.8.0

# Run with environment variables
docker run --pull always --rm -it \
  --env-file .env \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:0.8.0 orbis compute-software \
  -s START_DATE \
  -e END_DATE \
  -b BASE_DOMAIN
```

### Diagnostic Scanner
```bash
# Create support bundle for troubleshooting
docker run --pull always --rm -it \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:0.8.0 orbis scanner create \
  -n astronomer --image quay.io/astronomer/orbis-scanner:0.8.0
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
