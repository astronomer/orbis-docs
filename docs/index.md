---
title: "Orbis"
slug: /
description: "Use Orbis to collect diagnostics and generate compute reports for Astro Private Cloud."
hide-nav-links: true
hide-feedback: true
---

# Orbis

![Orbis Logo](assets/orbis_logo.png){width=50% height=auto}

Orbis is a diagnostic and reporting tool for Astronomer platforms. It collects support bundles from Kubernetes clusters and generates deployment compute reports.

Orbis collects metrics from Prometheus and deployment metadata from the Houston API to analyze Astro Private Cloud (APC) environments.

## Get started

- [Install Orbis](get-started/install.md)
- [Configure Orbis](get-started/configure.md)

## Generate reports

- [Generate a compute report](reporting/generate-report.md)
- [Manual Prometheus diagnostics](reporting/manual-prometheus-diagnostics.md)

## Collect diagnostics

- [Create a support bundle](scanner/create-support-bundle.md)
- [Collect from multi-cluster environments](scanner/multi-cluster-guide.md)
- [Resume and merge sessions](scanner/resume-sessions.md)

## How it works

### Reporting

```mermaid
graph LR
    CLI["orbis command<br/><code>reporting</code>"]
    HOUSTON["Houston API<br/><small>GraphQL</small>"]
    PROM["Prometheus<br/><small>PromQL</small>"]
    GEN["Report generator"]
    OUT["DOCX · CSV · JSON"]

    CLI -->|"fetch deployment<br/>metadata"| HOUSTON
    CLI -->|"fetch CPU, memory,<br/>task metrics"| PROM
    HOUSTON --> GEN
    PROM --> GEN
    GEN -->|"visualize &<br/>package"| OUT

    linkStyle 0 stroke:#00e5ff,color:#00e5ff
    linkStyle 1 stroke:#00e5ff,color:#00e5ff
    linkStyle 2 stroke:#00e5ff,color:#00e5ff
    linkStyle 3 stroke:#00e5ff,color:#00e5ff
    linkStyle 4 stroke:#00e5ff,color:#00e5ff
```

### Scanner (support bundle)

```mermaid
graph LR
    CLI2["orbis command<br/><code>scanner create</code>"]
    DISC["Houston API<br/><small>discover topology</small>"]
    CP["Control plane cluster<br/><small>scanner pod</small>"]
    DP["Data plane cluster(s)<br/><small>scanner pod</small>"]
    MERGE["Merge &<br/>package"]
    BUNDLE["support-bundle.tar.gz"]

    CLI2 -->|"discover<br/>split topology"| DISC
    CLI2 -->|"create RBAC +<br/>Job"| CP
    CLI2 -->|"create RBAC +<br/>Job"| DP
    CP -->|"kubectl, helm,<br/>telescope"| MERGE
    DP -->|"kubectl, helm,<br/>telescope"| MERGE
    MERGE --> BUNDLE

    linkStyle 0 stroke:#00e5ff,color:#00e5ff
    linkStyle 1 stroke:#00e5ff,color:#00e5ff
    linkStyle 2 stroke:#00e5ff,color:#00e5ff
    linkStyle 3 stroke:#00e5ff,color:#00e5ff
    linkStyle 4 stroke:#00e5ff,color:#00e5ff
    linkStyle 5 stroke:#00e5ff,color:#00e5ff
```

The reporting flow queries the Houston API for deployment metadata and Prometheus for time-series metrics, then generates visualizations and packages results into DOCX, CSV, and JSON files.

The scanner flow discovers the APC cluster topology from Houston, creates scanner pods on the control plane and data plane clusters through Kubernetes jobs, collects diagnostic data using kubectl, Helm, and telescope, and merges everything into a single support bundle.

{% if not config.extra.is_external %}
## Development

- [Set up local development](development/local-development-setup.md)
- [Contribute to orbis](development/contributing.md)
- [Build the documentation](development/building_docs.md)
- [Build the container image](development/docker-build.md)
- [Release process](development/release-process.md)
{% endif %}

## Changelog

See the [changelog](changelog.md) for release history.
