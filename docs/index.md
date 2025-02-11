# Orbis - Astronomer Software Deployment Compute Report Generator

Orbis is a deployment compute report generator tool that analyzes data from Astronomer Software to provide insights into deployment metrics and resource utilization.

## Key Features

- Comprehensive deployment metrics analysis
- Resource utilization tracking
- Custom resource allocation support
- PDF report generation
- Docker-based deployment for easy setup

## Quick Start with Docker (Recommended)

1. Create a `.env` file with your configuration:
   ```env
   ASTRO_SOFTWARE_API_TOKEN=your_token_here
   ```

2. Run Orbis using Docker:
   ```bash
   docker run --pull always --rm -it \
     --env-file .env \
     -v $(pwd)/output:/app/output \
     quay.io/astronomer/orbis:0.6.1 orbis compute-software \
     -s START_DATE \
     -e END_DATE \
     -o ORGANIZATION_ID \
     [-v] [-w WORKSPACES] [-z] [-r] [-p]
   ```

## Documentation Sections

- [Installation](installation.md)
- [Usage Guide](usage/software_usage.md)
- Modules
    - API
        - [Houston](modules/api/houston.md)
        - [Prometheus](modules/api/prometheus.md)
    - Report
        - [Generator](modules/report/generator.md)
        - [Visualizer](modules/report/visualizer.md)
        - [CSV Generator](modules/report/csv_generator.md)
    - [Data Models](modules/data_models.md)
- [Reports](reports.md)

## Support

For support, please contact [success@astronomer.io](mailto:success@astronomer.io)
