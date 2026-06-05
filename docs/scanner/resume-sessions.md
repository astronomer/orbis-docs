---
title: "Resume scanner sessions"
slug: resume-scanner-sessions
description: "Resume and merge Orbis scanner sessions across separated clusters."
hide-nav-links: true
hide-feedback: true
---

# Resume and merge sessions

Use resume commands when the control plane (CP) and data planes (DPs) are in separate cloud accounts and must be collected in separate runs.

Keep the same output folder mounted for every Podman resume command. Session metadata is stored under the output folder, so later `resume continue` and `resume merge` commands need access to the same files.

## Direct command line

Step 1: collect the CP first. Orbis prints a session ID.

```bash
orbis scanner create \
  -n <cp-namespace> \
  -d <base-domain> \
  --version <platform-version> \
  --cp-kubeconfig <path-to-cp-kubeconfig>
```

Step 2: add DP1.

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

## Podman

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
