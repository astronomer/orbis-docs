# Orbis Documentation
<div style="text-align:center">
   <img src="docs/assets/orbis_logo.svg" width="50%" alt="Orbis Logo">
</div>

Orbis is a diagnostic and reporting tool for Astro Private Cloud (formerly Astronomer Software). It collects support bundles from Kubernetes clusters and generates deployment compute reports.

## Key Features

1. **Report Generation**: Deployment metrics analysis including CPU usage, memory consumption, resource allocation, task success/failure rates, processing trends, and execution latency. Outputs DOCX, CSV, and JSON reports.
2. **Diagnostic Scanner**: Creates support bundles containing Kubernetes cluster information, Astronomer deployment details, logs, and configurations. Supports CP/DP multi-cluster collection, session management, and incremental resume workflows.

## Quick Start

### Report Generation
```bash
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
docker run --pull always --rm -it \
  -v $(pwd)/output:/app/output \
  -v ~/.kube:/root/.kube:ro \
  quay.io/astronomer/orbis:0.8.0 orbis scanner create \
  -n astronomer \
  --image quay.io/astronomer/orbis-scanner:0.8.0
```

## Documentation

- **Get started** — installation and configuration
- **Reporting** — compute report generation, CLI reference, Prometheus diagnostics
- **Scanner** — support bundle creation, multi-cluster collection, resume and merge
- **Changelog** — release history

## Syncing from orbis repo

This repo contains the customer-facing subset of the orbis documentation. The source of truth is the `orbis` repo's `docs/` directory. To sync:

```bash
./scripts/sync-docs.sh /path/to/orbis
```

## Local preview

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python -m mkdocs serve -f mkdocs.yaml
```

## Support

If you encounter any issues, please:
1. Check the documentation in this repository
2. Create a new issue using our issue templates

## License

Copyright (c) 2021 Astronomer, LLC
