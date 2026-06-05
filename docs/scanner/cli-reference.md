---
title: "Scanner command reference"
slug: scanner-cli-reference
description: "Review Orbis scanner and resume command-line options."
hide-nav-links: true
hide-feedback: true
---

# Scanner command reference

## scanner create

Create and run the diagnostic scanner.

```bash
orbis scanner create -n <namespace> [OPTIONS]
```

The default container image is `quay.io/astronomer/orbis:<version>`, where `<version>` is the Orbis command-line interface (CLI) version on the host. Override with `--image` when the cluster needs to pull from a different registry.

### Namespace options

| Flag | Description |
|---|---|
| `-n, --namespace` | Platform namespace for single-cluster scans. Also accepted as the control plane namespace when `--cp-namespace` is omitted. |
| `--cp-namespace` | Control plane namespace for split scans. |

### Common options

| Flag | Description | Default |
|---|---|---|
| `--image` | Container image for the scanner pod. | `quay.io/astronomer/orbis:<cli-version>` |
| `--interactive` | Generate YAML for manual application. Single-cluster only. | — |
| `--output-file` | Output file for YAML generation. | — |
| `-d, --domain` | Astronomer base domain. | — |
| `-c, --cluster` | Cluster name identifier. | — |
| `--kubeconfig` | Path to the kubeconfig file. | — |
| `--cpu` | CPU cores for the scanner pod. | `1` |
| `--memory` | Memory for the scanner pod. | `1Gi` |
| `--sleep` | Sleep time in seconds. Minimum: 3600. | `86400` |
| `--cleanup` / `--no-cleanup` | Clean up resources after completion. | cleanup |
| `--log-level` | Logging level: `warn`, `info`, or `debug`. | `info` |
| `-v, --verbose` | Increase verbosity (`-v`, `-vv`, `-vvv`). | — |
| `--airflow-namespaces` | Restrict in-cluster collection to these Airflow namespaces. Repeatable. When omitted, every platform-labeled Airflow namespace is collected. | — |
| `--poll-interval` | Polling interval in seconds. | `10` |
| `--poll-timeout` | Overall polling timeout in seconds. | `3600` |

### Multi-cluster options

Use these flags for Astro Private Cloud (APC) 1.x and later environments with a control plane (CP) and one or more data planes (DPs). Any of the following flags switches Orbis into multi-cluster mode. The active topology is inferred from which flags are present.

| Flag | Description |
|---|---|
| `--version` | APC platform version, for example `1.1.0`. Required for multi-cluster mode. |
| `--cp-namespace` | Control plane namespace. Defaults to `-n`. |
| `--cp-kubeconfig` | Kubeconfig file for the control plane cluster. |
| `--dpN-namespace` | Data plane namespace for the Nth data plane (N is any positive integer). |
| `--dpN-kubeconfig` | Kubeconfig file for the Nth data plane. |
| `--dpN-af-namespaces` | Comma-separated Airflow namespaces to collect on the Nth data plane. When omitted, every Airflow namespace on that data plane is collected. |
| `--skip-discovery` | Skip Houston API topology discovery when no `--dpN-*` flags are provided. |
| `--no-auto-merge` | Disable automatic tar merge when all clusters complete. |

Example with two data planes on separate clusters:

```bash
orbis scanner create \
  -d <base-domain> \
  --version <platform-version> \
  --cp-namespace <cp-namespace> \
  --cp-kubeconfig <path-to-cp-kubeconfig> \
  --dp1-namespace <dp1-platform-namespace> \
  --dp1-kubeconfig <path-to-dp1-kubeconfig> \
  --dp1-af-namespaces <dp1-airflow-namespace-a>,<dp1-airflow-namespace-b> \
  --dp2-namespace <dp2-platform-namespace> \
  --dp2-kubeconfig <path-to-dp2-kubeconfig>
```

### Generate scanner YAML interactively

Use `--interactive` when you need to generate scanner YAML for an infrastructure team to apply manually. This mode is single-cluster only; it is not supported with `--cp-*` or `--dpN-*` flags.

Direct command line:

```bash
orbis scanner create \
  -n <platform-namespace> \
  --kubeconfig <path-to-kubeconfig> \
  --interactive \
  --output-file scanner-bundle.yaml
```

The infrastructure team applies the YAML:

```bash
kubectl apply -f scanner-bundle.yaml
```

When the scanner pod completes, retrieve the bundle:

```bash
orbis scanner retrieve \
  -n <platform-namespace> \
  --kubeconfig <path-to-kubeconfig> \
  --output-dir ./output
```

Clean up scanner resources:

```bash
orbis scanner clean \
  -n <platform-namespace> \
  --kubeconfig <path-to-kubeconfig>
```

Podman:

```bash
podman run --rm -it \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner create \
  -n <platform-namespace> \
  --interactive \
  --output-file /app/output/scanner-bundle.yaml
```

Retrieve with Podman after the YAML has run:

```bash
podman run --rm -it \
  -v ~/path/to/kubeconfig:/kubeconfigs/unified_kubeconfig:ro \
  -v $(pwd)/output:/app/output \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner retrieve \
  -n <platform-namespace> \
  --kubeconfig /kubeconfigs/unified_kubeconfig \
  --output-dir /app/output
```

## scanner discover

Query the Houston API to display CP/DP topology without requiring Kubernetes access.

```bash
orbis scanner discover -d <domain> --version <version> [OPTIONS]
```

Requires the `ASTRO_SOFTWARE_API_TOKEN` environment variable.

| Flag | Description | Default |
|---|---|---|
| `-d, --domain` | Astronomer base domain. Required. | — |
| `--version` | APC version. Required. | — |
| `--json` | Output as JSON. | off |
| `--output-dir` | Save the discovery artifact to a folder. | — |
| `--probe` | Test Commander endpoint reachability per data plane. | off |
| `--verify-ssl` / `--no-verify-ssl` | Enable or disable SSL certificate verification. | verify |
| `-v, --verbose` | Increase verbosity. | — |

## scanner retrieve

Retrieve data from an existing scanner pod.

```bash
orbis scanner retrieve -n <namespace> [OPTIONS]
```

| Flag | Description | Default |
|---|---|---|
| `-n, --namespace` | Namespace. Required. | — |
| `--pod-name` | Specific pod name to retrieve from. | — |
| `--output-dir` | Folder to save the retrieved data to. | `.` |
| `--cleanup` / `--no-cleanup` | Clean up resources after retrieving. | cleanup |
| `-v, --verbose` | Increase verbosity. | — |
| `--kubeconfig` | Path to the kubeconfig file. | — |

## scanner status

Check the status of a running scanner job.

```bash
orbis scanner status -n <namespace> [OPTIONS]
```

| Flag | Description |
|---|---|
| `-n, --namespace` | Namespace. Required. |
| `-v, --verbose` | Increase verbosity. |
| `--kubeconfig` | Path to the kubeconfig file. |

## scanner clean

Clean up scanner resources.

```bash
orbis scanner clean -n <namespace> [OPTIONS]
```

Orbis removes the scanner Job and pods, the `temp-scanner-support-bundle` ServiceAccount, the `read-support-bundle` ClusterRole, and the `scanner-admin-access-binding` ClusterRoleBinding.

| Flag | Description |
|---|---|
| `-n, --namespace` | Namespace. Required. |
| `--dry-run` | Show commands without executing them. |
| `-v, --verbose` | Increase verbosity. |
| `--kubeconfig` | Path to the kubeconfig file. |
| `--cp-namespace` | Control plane namespace for CP/DP cleanup. |
| `--cp-kubeconfig` | Control plane kubeconfig for CP/DP cleanup. |
| `--dpN-namespace` | Data plane namespace for CP/DP cleanup. |
| `--dpN-kubeconfig` | Data plane kubeconfig for CP/DP cleanup. |

## resume list

List all collection sessions.

```bash
orbis resume list
```

## resume continue

Resume an interrupted session or add new data planes.

```bash
orbis resume continue --session-id <session-id> --image <image> -n <namespace> [OPTIONS]
```

| Flag | Description |
|---|---|
| `--session-id` | Session to resume. Required. |
| `--image` | Scanner container image. Required. |
| `-n, --namespace` | Namespace. Required. |
| `--add-dp` | Add a new data plane to this session. |
| `--add-dp-kubeconfig` | Kubeconfig path for the new data plane. |
| `--add-dp-namespace` | Namespace for the new data plane. |
| `--add-dp-cluster-id` | Cluster ID from `scanner discover` to match a specific data plane. |
| `--cp-kubeconfig` | Override the control plane kubeconfig path for retry. |
| `--dp-kubeconfig` | Override the data plane kubeconfig path for retry. |
| `--no-auto-merge` | Disable automatic merge on completion. |
| `-v, --verbose` | Increase verbosity. |

Add a data plane with the direct command line:

```bash
orbis resume continue \
  --session-id <session-id> \
  --image quay.io/astronomer/orbis:<orbis-version> \
  -n <dp-platform-namespace> \
  --add-dp \
  --add-dp-kubeconfig <path-to-dp-kubeconfig> \
  --add-dp-cluster-id <dp-cluster-id>
```

Add a data plane with Podman:

```bash
podman run --rm -it \
  -v ~/path/to/dp-kubeconfig:/kubeconfigs/dp_kubeconfig:ro \
  -v $(pwd)/output:/app/output \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  resume continue \
  --session-id <session-id> \
  --image quay.io/astronomer/orbis:<orbis-version> \
  -n <dp-platform-namespace> \
  --add-dp \
  --add-dp-kubeconfig /kubeconfigs/dp_kubeconfig \
  --add-dp-cluster-id <dp-cluster-id>
```

When using Podman, mount the same `$(pwd)/output:/app/output` folder for every resume command so Orbis can read and update the session metadata.

## resume merge

Merge completed CP/DP artifacts into a single tar file.

```bash
orbis resume merge --session-id <session-id> [--output-dir <output-dir>]
```

Podman:

```bash
podman run --rm -it \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  resume merge \
  --session-id <session-id> \
  --output-dir /app/output
```
