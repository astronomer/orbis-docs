# Orbis - Astronomer Software Deployment Compute Report Generator

Orbis is a powerful deployment compute report generator tool that analyzes data from Astronomer Software to provide insights into deployment metrics and resource utilization.

## Key Features

- Comprehensive deployment metrics analysis
- Resource utilization tracking
- Custom resource allocation support
- Detailed PDF report generation
- Docker-based deployment for easy setup

## Quick Start with Docker (Recommended)

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

## Documentation Sections

- [Installation](installation.md)
- [Configuration](configuration.md)
- [Usage Guide](usage/software_usage.md)
- [CLI Reference](cli.md)
- [Contributing](contributing.md)
- [Changelog](changelog.md)

## Support

For support, please contact [success@astronomer.io](mailto:success@astronomer.io)