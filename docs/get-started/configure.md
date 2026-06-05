---
title: "Configure Orbis"
slug: configure-orbis
description: "Configure Orbis environment variables and query files."
hide-nav-links: true
hide-feedback: true
---

# Configure Orbis

## Environment variables

Create a `.env` file in the project root with the following variables:

```bash
ASTRO_SOFTWARE_API_TOKEN=<your-houston-api-token>
```

| Variable | Description |
|---|---|
| `ASTRO_SOFTWARE_API_TOKEN` | Houston API token with the `SYSTEM_ADMIN` role. Required for reporting and scanner discovery. |

No browser path environment variable is required. The Podman image includes the browser and runtime dependencies used for report rendering, and local package installs should resolve those dependencies during installation.

### Generate a Houston API token

1. Open `https://houston.<your-base-domain>/v1` in a browser.
2. Run the following GraphQL mutation:

    ```graphql
    mutation create_system_service_account {
        createSystemServiceAccount(label: "orbis", role: SYSTEM_ADMIN) {
            apiKey
            roleBindings {
                role
            }
        }
    }
    ```

3. Copy the `apiKey` value from the response and add it to your `.env` file.

## Query configuration files

Orbis uses YAML files to define the queries it runs against Prometheus and Houston.

| File | Description |
|---|---|
| `prometheus_queries.yaml` | PromQL queries for CPU, memory, pod count, and task metrics |
| `houston_queries.yaml` | GraphQL queries for deployment metadata from the Houston API |
| `csv_template.csv` | Template for CSV report output |

These files are bundled with Orbis at `src/orbis/config/`. To override them, set the following values in `settings.py`:

- `SOFTWARE_QUERIES_FILE_PATH`: path to a custom Prometheus queries file
- `CSV_TEMPLATE_PATH`: path to a custom CSV template

## Settings reference

Orbis loads configuration from `src/orbis/config/settings.py`:

| Setting | Description |
|---|---|
| `SOFTWARE_QUERIES_FILE_PATH` | Path to the Prometheus queries YAML file |
| `CSV_TEMPLATE_PATH` | Path to the CSV template file |
| `KE_QUERIES`, `CELERY_QUERIES`, `SCHEDULER_QUERIES` | Query type constants |
| `COLORS` | Color palette for graph visualizations |
| `DECIMAL_PRECISION` | Decimal precision for metric calculations |
