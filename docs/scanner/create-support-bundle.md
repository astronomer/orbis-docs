---
title: "Create scanner support bundles"
slug: create-scanner-support-bundles
description: "Create, retrieve, and clean up Orbis scanner support bundles."
hide-nav-links: true
hide-feedback: true
---

# Create scanner support bundles

Use `orbis scanner create` to collect Kubernetes diagnostics into a support bundle. Use `orbis scanner clean` to remove scanner resources after collection.

Replace every value in angle brackets before running the commands.

## Prerequisites

- A kubeconfig for every cluster you want to scan.
- Kubernetes permissions to create and delete scanner role-based access control (RBAC), ServiceAccounts, Jobs, and pods.
- Target clusters can pull the Orbis image.
- For Amazon Elastic Kubernetes Service (EKS) kubeconfigs, the Podman examples mount `~/.aws` and pass `AWS_PROFILE`. Adjust those mounts for Google Kubernetes Engine (GKE) or Azure Kubernetes Service (AKS) authentication.

## Direct command line

Use this when the Orbis command-line interface (CLI) is installed locally.

These examples cover unified and split Astro Private Cloud (APC) topologies. A split topology has a control plane (CP) and one or more data planes (DPs).

### Unified or APC 0.x

```bash
orbis scanner create \
  -n <platform-namespace> \
  --kubeconfig <path-to-unified-kubeconfig> \
  -d <base-domain> \
  --image quay.io/astronomer/orbis:<orbis-version> \
  --log-level debug \
  --no-cleanup
```

Optional platform version:

```bash
--version <platform-version>
```

### Generate scanner YAML interactively

Use `--interactive` when you cannot create scanner resources directly and need an infrastructure team to apply YAML manually. This mode is single-cluster only.

Generate the YAML:

```bash
orbis scanner create \
  -n <platform-namespace> \
  --kubeconfig <path-to-kubeconfig> \
  --interactive \
  --output-file scanner-bundle.yaml
```

The infrastructure team applies it:

```bash
kubectl apply -f scanner-bundle.yaml
```

After the scanner pod completes, retrieve the support bundle:

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

### CP/DP with two data planes

```bash
orbis scanner create \
  -d <base-domain> \
  --version <platform-version> \
  --cp-namespace <cp-namespace> \
  --cp-kubeconfig <path-to-cp-kubeconfig> \
  --dp1-namespace <dp1-platform-namespace> \
  --dp1-kubeconfig <path-to-dp1-kubeconfig> \
  --dp2-namespace <dp2-platform-namespace> \
  --dp2-kubeconfig <path-to-dp2-kubeconfig>
```

### CP/DP with Airflow namespace filters

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
  --dp2-kubeconfig <path-to-dp2-kubeconfig> \
  --dp2-af-namespaces <dp2-airflow-namespace-a>
```

### Incremental collection

Use this when the CP and DPs are in separate cloud accounts and you cannot authenticate to all clusters at the same time.

Step 1: collect the CP first. The missing DPs are registered as pending.

```bash
orbis scanner create \
  -n <cp-namespace> \
  -d <base-domain> \
  --version <platform-version> \
  --cp-kubeconfig <path-to-cp-kubeconfig>
```

Step 2: add DP1. Use the session ID from step 1.

```bash
orbis resume continue \
  --session-id <session-id> \
  --image quay.io/astronomer/orbis:<orbis-version> \
  -n <dp1-platform-namespace> \
  --add-dp \
  --add-dp-kubeconfig <path-to-dp1-kubeconfig> \
  --add-dp-cluster-id <dp1-cluster-id>
```

Step 3: add DP2.

```bash
orbis resume continue \
  --session-id <session-id> \
  --image quay.io/astronomer/orbis:<orbis-version> \
  -n <dp2-platform-namespace> \
  --add-dp \
  --add-dp-kubeconfig <path-to-dp2-kubeconfig> \
  --add-dp-cluster-id <dp2-cluster-id>
```

Manual merge if auto-merge did not run:

```bash
orbis resume merge --session-id <session-id>
```

### Clean up

Unified or APC 0.x cleanup:

```bash
orbis scanner clean \
  -n <platform-namespace> \
  --kubeconfig <path-to-unified-kubeconfig>
```

CP/DP cleanup:

```bash
orbis scanner clean \
  --cp-namespace <cp-namespace> \
  --cp-kubeconfig <path-to-cp-kubeconfig> \
  --dp1-namespace <dp1-platform-namespace> \
  --dp1-kubeconfig <path-to-dp1-kubeconfig> \
  --dp2-namespace <dp2-platform-namespace> \
  --dp2-kubeconfig <path-to-dp2-kubeconfig> \
  -d <base-domain>
```

## Podman

Use this when you do not want to install the Orbis CLI locally. The Orbis image entrypoint is already `orbis`, so the command after the image starts with `scanner` or `resume`.

The examples mount only the kubeconfig files that Orbis needs.

Mount `~/.aws` and pass `AWS_PROFILE` only when the mounted kubeconfig needs AWS authentication.

### Unified or APC 0.x

```bash
podman run --rm -it \
  -v ~/path/to/unified-kubeconfig:/kubeconfigs/unified_kubeconfig:ro \
  -v $(pwd)/output:/app/output \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner create \
  -n <platform-namespace> \
  --kubeconfig /kubeconfigs/unified_kubeconfig \
  -d <base-domain> \
  --image quay.io/astronomer/orbis:<orbis-version> \
  --log-level debug \
  --no-cleanup
```

### Generate scanner YAML interactively

Generate scanner YAML with Podman:

```bash
podman run --rm -it \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner create \
  -n <platform-namespace> \
  --interactive \
  --output-file /app/output/scanner-bundle.yaml
```

The infrastructure team applies the generated file:

```bash
kubectl apply -f output/scanner-bundle.yaml
```

Retrieve the completed bundle with Podman:

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

### CP/DP with two data planes

```bash
podman run --rm -it \
  -v ~/path/to/cp-kubeconfig:/kubeconfigs/cp_kubeconfig:ro \
  -v ~/path/to/dp1-kubeconfig:/kubeconfigs/dp1_kubeconfig:ro \
  -v ~/path/to/dp2-kubeconfig:/kubeconfigs/dp2_kubeconfig:ro \
  -v $(pwd)/output:/app/output \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner create \
  -d <base-domain> \
  --version <platform-version> \
  --cp-namespace <cp-namespace> \
  --cp-kubeconfig /kubeconfigs/cp_kubeconfig \
  --dp1-namespace <dp1-platform-namespace> \
  --dp1-kubeconfig /kubeconfigs/dp1_kubeconfig \
  --dp2-namespace <dp2-platform-namespace> \
  --dp2-kubeconfig /kubeconfigs/dp2_kubeconfig
```

### CP/DP with Airflow namespace filters

```bash
podman run --rm -it \
  -v ~/path/to/cp-kubeconfig:/kubeconfigs/cp_kubeconfig:ro \
  -v ~/path/to/dp1-kubeconfig:/kubeconfigs/dp1_kubeconfig:ro \
  -v ~/path/to/dp2-kubeconfig:/kubeconfigs/dp2_kubeconfig:ro \
  -v $(pwd)/output:/app/output \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner create \
  -d <base-domain> \
  --version <platform-version> \
  --cp-namespace <cp-namespace> \
  --cp-kubeconfig /kubeconfigs/cp_kubeconfig \
  --dp1-namespace <dp1-platform-namespace> \
  --dp1-kubeconfig /kubeconfigs/dp1_kubeconfig \
  --dp1-af-namespaces <dp1-airflow-namespace-a>,<dp1-airflow-namespace-b> \
  --dp2-namespace <dp2-platform-namespace> \
  --dp2-kubeconfig /kubeconfigs/dp2_kubeconfig \
  --dp2-af-namespaces <dp2-airflow-namespace-a>
```

### Incremental collection

Step 1: collect the CP first.

```bash
podman run --rm -it \
  -v ~/path/to/cp-kubeconfig:/kubeconfigs/cp_kubeconfig:ro \
  -v $(pwd)/output:/app/output \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner create \
  -n <cp-namespace> \
  -d <base-domain> \
  --version <platform-version> \
  --cp-kubeconfig /kubeconfigs/cp_kubeconfig
```

Step 2: add DP1.

```bash
podman run --rm -it \
  -v ~/path/to/dp1-kubeconfig:/kubeconfigs/dp1_kubeconfig:ro \
  -v $(pwd)/output:/app/output \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  resume continue \
  --session-id <session-id> \
  --image quay.io/astronomer/orbis:<orbis-version> \
  -n <dp1-platform-namespace> \
  --add-dp \
  --add-dp-kubeconfig /kubeconfigs/dp1_kubeconfig \
  --add-dp-cluster-id <dp1-cluster-id>
```

Step 3: add DP2.

```bash
podman run --rm -it \
  -v ~/path/to/dp2-kubeconfig:/kubeconfigs/dp2_kubeconfig:ro \
  -v $(pwd)/output:/app/output \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  resume continue \
  --session-id <session-id> \
  --image quay.io/astronomer/orbis:<orbis-version> \
  -n <dp2-platform-namespace> \
  --add-dp \
  --add-dp-kubeconfig /kubeconfigs/dp2_kubeconfig \
  --add-dp-cluster-id <dp2-cluster-id>
```

Manual merge:

```bash
podman run --rm -it \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  resume merge \
  --session-id <session-id> \
  --output-dir /app/output
```

### Clean up

Unified or APC 0.x cleanup:

```bash
podman run --rm -it \
  -v ~/path/to/unified-kubeconfig:/kubeconfigs/unified_kubeconfig:ro \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner clean \
  -n <platform-namespace> \
  --kubeconfig /kubeconfigs/unified_kubeconfig
```

CP/DP cleanup:

```bash
podman run --rm -it \
  -v ~/path/to/cp-kubeconfig:/kubeconfigs/cp_kubeconfig:ro \
  -v ~/path/to/dp1-kubeconfig:/kubeconfigs/dp1_kubeconfig:ro \
  -v ~/path/to/dp2-kubeconfig:/kubeconfigs/dp2_kubeconfig:ro \
  -v ~/.aws:/home/nonroot/.aws:ro \
  -e AWS_PROFILE \
  quay.io/astronomer/orbis:<orbis-version> \
  scanner clean \
  --cp-namespace <cp-namespace> \
  --cp-kubeconfig /kubeconfigs/cp_kubeconfig \
  --dp1-namespace <dp1-platform-namespace> \
  --dp1-kubeconfig /kubeconfigs/dp1_kubeconfig \
  --dp2-namespace <dp2-platform-namespace> \
  --dp2-kubeconfig /kubeconfigs/dp2_kubeconfig \
  -d <base-domain>
```
