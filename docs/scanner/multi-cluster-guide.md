---
title: "Collect from split environments"
slug: collect-from-split-environments
description: "Collect Orbis scanner diagnostics from control plane and data plane environments."
hide-nav-links: true
hide-feedback: true
---

# Collect from split environments

Use split mode when the Astro Private Cloud (APC) control plane (CP) and data planes (DPs) are in separate namespaces or separate Kubernetes clusters.

The full direct command-line and Podman command list is in [Create scanner support bundles](create-support-bundle.md). This guide summarizes the CP/DP command format.

## Direct command line

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

Restrict collection to specific Airflow namespaces on each data plane:

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

## Podman

Mount one kubeconfig file per target and pass the mounted paths to Orbis.

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

## Clean up

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
