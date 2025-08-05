# Installation Guide

## 1. Docker (Recommended)

The recommended way to run Orbis is using Docker. This ensures consistent behavior across different environments and simplifies the setup process.

### Prerequisites

1. Install [Docker](https://docs.docker.com/get-docker/)

### Docker Setup

```bash
# Pull the latest version
docker pull quay.io/astronomer/orbis:0.8.0
```

Create a `.env` file with your configuration:

```
ASTRO_SOFTWARE_API_TOKEN=your_token_here
```

## 2. Python Installation (Development)

!!! note "Python Requirements"

    Orbis 0.8.0 requires Python 3.10 or higher.

For development or local installation:

1. Clone the repository:
   ```bash
   git clone https://github.com/astronomer/orbis.git
   cd orbis
   ```

2. Create and activate a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install with development dependencies:
   ```bash
   pip install -e ".[dev]"
   ```

## 3. Astral `uv`

### Prerequisites

1. Install [uv](https://docs.astral.sh/uv/getting-started/installation/).

### Command
```bash
uvx --from astronomer-orbis orbis
```

## Chrome/Chromium Setup for Image Generation

Orbis uses Kaleido 1.0+ for generating static images from plots, which requires Chrome or Chromium to be installed on your system.

**Linux:**
```bash
sudo apt-get install chromium-browser
export BROWSER_PATH=/usr/bin/chromium-browser
```

**macOS:**
```bash
brew install --cask google-chrome
export BROWSER_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
```

**Windows:**
Install [Google Chrome](https://www.google.com/chrome/) and set:
```cmd
set BROWSER_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe"
```

## Configuration

After installation, you'll need to configure Orbis with your credentials and configuration. See the [Software Reports](usage/software_reports.md) usage guide for detailed setup instructions.

