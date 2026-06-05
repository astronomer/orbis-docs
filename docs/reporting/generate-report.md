---
title: "Generate a compute report"
slug: generate-compute-report
description: "Generate Astro Private Cloud compute reports with Orbis reporting."
hide-nav-links: true
hide-feedback: true
---

# Generate a compute report

Use `orbis reporting` to generate Astro Private Cloud (APC) deployment compute reports. Reporting pulls deployment metadata from Houston and metrics from Prometheus, then writes DOCX, CSV, and JSON artifacts.

Replace every value in angle brackets before running the commands.

## What reporting does

Reporting collects:

- Deployment metadata, workspace metadata, executor type, Apache Airflow (Airflow) version, and replica information from Houston.
- Scheduler, worker, KubernetesPodOperator (KPO), Kubernetes executor, task success, and task failure metrics from Prometheus.
- APC 1.x component metrics for triggerer and webserver. Airflow 3 reports also include Dag processor and API server metrics.
- Optional workspace-filtered output when `-w <workspace-id>,<workspace-id>` is provided.

The Prometheus query list is documented in [Manual Prometheus diagnostics](manual-prometheus-diagnostics.md).

## Date range

The end date is not inclusive. To include the last day of a month, set `-e` to the first day of the next month.

Examples:

- To report May 20 through May 22, use `-s 2026-05-20 -e 2026-05-23`.
- To report all of May 2026, use `-s 2026-05-01 -e 2026-06-01`.

## Prerequisites

- A Houston API token exported as `ASTRO_SOFTWARE_API_TOKEN`.
- Network access to the APC base domain and Prometheus endpoints.
- Orbis installed locally, or Podman available to run the Orbis image.

## Direct command line

Use this when the Orbis command-line interface (CLI) is installed on your workstation or bastion host.

The following examples cover unified and split topologies. A split topology has a control plane (CP) and one or more data planes (DPs).

### APC 0.x or unified topology

```bash
export ASTRO_SOFTWARE_API_TOKEN=<your-token>

orbis reporting \
  -s <start-date> -e <exclusive-end-date> \
  -b <base-domain> \
  --version <platform-version> -vvv -r -p -z
```

`--version` is optional. When omitted, Orbis auto-infers the version from the Houston `appConfig` API. Pass it explicitly to validate the inferred version or when Houston is unreachable.

### CP/DP split topology

```bash
export ASTRO_SOFTWARE_API_TOKEN=<your-token>

orbis reporting \
  -s <start-date> -e <exclusive-end-date> \
  -b <base-domain> \
  --version <platform-version> -vvv -r -p -z
```

In CP/DP mode, Orbis uses Houston metadata to map deployments to data planes and auto-discovers per-data-plane Prometheus endpoints by default.

If metrics are exposed through a single external Prometheus, pass the endpoint explicitly:

```bash
orbis reporting \
  -s <start-date> -e <exclusive-end-date> \
  -b <base-domain> \
  --version <platform-version> -vvv -r -p -z \
  --prometheus-url <prometheus-url> \
  --prometheus-token <prometheus-token>
```

## Podman

The Orbis image entrypoint is already `orbis`, so the command after the image starts with `reporting`.

### APC 0.x or unified topology

```bash
podman run --rm -it \
  -e ASTRO_SOFTWARE_API_TOKEN=<your-token> \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  reporting \
  -s <start-date> -e <exclusive-end-date> \
  -b <base-domain> \
  --version <platform-version> -vvv -r -p -z
```

### CP/DP split topology

```bash
podman run --rm -it \
  -e ASTRO_SOFTWARE_API_TOKEN=<your-token> \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  reporting \
  -s <start-date> -e <exclusive-end-date> \
  -b <base-domain> \
  --version <platform-version> -vvv -r -p -z
```

With a single external Prometheus:

```bash
podman run --rm -it \
  -e ASTRO_SOFTWARE_API_TOKEN=<your-token> \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  reporting \
  -s <start-date> -e <exclusive-end-date> \
  -b <base-domain> \
  --version <platform-version> -vvv -r -p -z \
  --prometheus-url <prometheus-url> \
  --prometheus-token <prometheus-token>
```

### Use an environment file

Create a `.env` file:

```bash
ASTRO_SOFTWARE_API_TOKEN=<your-token>
```

Run reporting with the environment file:

```bash
podman run --rm -it \
  --env-file .env \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  reporting \
  -s <start-date> -e <exclusive-end-date> \
  -b <base-domain> \
  --version <platform-version> -vvv -r -p -z
```

## Flags used in the examples

| Flag | Meaning |
|---|---|
| `-s` | Report start date in `YYYY-MM-DD` format. |
| `-e` | Exclusive report end date in `YYYY-MM-DD` format. |
| `-b` | APC base domain. |
| `--version` | APC platform version. |
| `-vvv` | Debug logging. |
| `-r` | Resume from saved progress when possible. |
| `-p` | Persist temporary files in the output folder. |
| `-z` | Compress generated output. |
| `--prometheus-url` | Optional explicit Prometheus endpoint. |
| `--prometheus-token` | Optional token for the explicit Prometheus endpoint. |

## Output

Reports are written to `./output` on the host when using the preceding Podman examples. The reporting command generates DOCX, CSV, and JSON artifacts.
