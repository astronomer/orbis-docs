# Installation Guide

## 1. Docker (Recommended)


The recommended way to run Orbis is using Docker. This ensures consistent behavior across different environments and simplifies the setup process.

### Prerequisites

1. Install [Docker](https://docs.docker.com/get-docker/)
2. Ensure you have a valid Houston API token (with `SYSTEM_ADMIN` role) for authentication
   (_If only 1 workspace is specified, then you can use `WORKSPACE_ADMIN` token instead_)

### Docker Setup

```bash
# Pull the latest version
docker pull quay.io/astronomer/orbis:0.7.0
```

Create a `.env` file with your configuration:

```
ASTRO_SOFTWARE_API_TOKEN=your_token_here
```


## 2. Orbis CLI Binary

!!! warning

    Binaries are currently experimental.

If you prefer to run Orbis directly on your system, you can request the binary package from Astronomer. We provide pre-built binaries for:

- Linux (x86_64)
- macOS (x86_64, arm64)
- Windows (x86_64)

Please contact your Astronomer representative to obtain the appropriate binary for your platform. They will provide you with:

1. The binary package for your operating system
2. Instructions for setting up environment variables
3. Any additional configuration requirements

## Configuration

After installation, you'll need to configure Orbis with your credentials. You will need:

1. A valid Houston API token (with `SYSTEM_ADMIN` role) (Or `WORKSPACE_ADMIN` token if only 1 workspace is specified)
2. Your Organization ID
3. The reporting period (start and end dates)

See the [Usage Guide](usage/software_usage.md) for detailed setup instructions.

