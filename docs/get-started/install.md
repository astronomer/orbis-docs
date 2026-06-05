---
title: "Install Orbis"
slug: install-orbis
description: "Install Orbis with Podman, uv tool install, pip, or a release wheel."
hide-nav-links: true
hide-feedback: true
---

# Install Orbis

Choose one of the supported installation methods in this order. Astronomer recommends Podman because the image includes every dependency Orbis needs: Chrome, kubectl, Helm, and cloud authentication plugins.

| Method | Use this when |
|---|---|
| [Podman](#run-with-podman) | Recommended. You want zero local dependencies. |
| [uv tool install or pip](#install-with-pip-or-uv) | You want a local command on a workstation or bastion. |
| [Release wheel](#install-from-a-release-wheel) | You operate in an air-gapped or restricted environment and can provide the wheel plus dependencies. |

## Run with Podman

The Orbis image includes Chrome, kubectl, Helm, the Amazon Web Services (AWS) command-line interface, the gcloud authentication plugin, Azure Kubernetes authentication support, and aws-iam-authenticator. You don't need to install Orbis on the host.

Run any Orbis command by mounting an output folder:

```bash
podman run --rm -it \
  -e ASTRO_SOFTWARE_API_TOKEN=<your-houston-api-token> \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:<orbis-version> \
  --help
```

Reports and support bundles are written to `./output` on the host. For scanner commands, mount each required kubeconfig file individually, for example `-v ~/path/to/kubeconfig:/kubeconfigs/unified_kubeconfig:ro`.

## Install with pip or uv

### Prerequisites

- Python 3.10 or later

**Recommended — `uv tool install`:**

```bash
uv tool install astronomer-orbis
```

`uv tool install` installs Orbis as a CLI tool and automatically adds it to your PATH. This is the correct uv command for tools — `uv pip install` does not add the `orbis` command to your PATH.

Or install with `pip`:

```bash
pip install astronomer-orbis
```

Verify the installation:

```bash
orbis --help
```

No browser path configuration is required. Browser/runtime dependencies used for report rendering should be resolved by the installation path. If local dependency resolution is restricted by the host, use the Podman image instead.

## Install from a release wheel

Use this method only when PyPI and the container registry are unreachable.

1. Download the wheel from the [releases page](https://github.com/astronomer/orbis/releases){target="_blank"}.
2. Provide every dependency required by the wheel. In offline environments, place dependency wheels in a local wheelhouse.
3. Install the Orbis wheel.

    ```bash
    pip install orbis-<version>-py3-none-any.whl
    ```

    Offline wheelhouse example:

    ```bash
    pip install --no-index --find-links ./wheelhouse orbis-<version>-py3-none-any.whl
    ```

Do not install the wheel with `--no-deps` unless all required dependencies are already installed.

## After installation

Set the `ASTRO_SOFTWARE_API_TOKEN` environment variable. See [Configure Orbis](configure.md) for details.
