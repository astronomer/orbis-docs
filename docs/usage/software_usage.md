# Orbis Usage Guide for Software

This guide explains how to use Orbis to generate compute reports for Astronomer Software deployments.

## Prerequisites

1. Docker installed (recommended)
2. Houston API token with SYSTEM_ADMIN role
3. Organization domain for Astronomer Software
4. Start and end dates for the report period

## Using Docker (Recommended)

1. Create a `.env` file with your configuration:
   ```env
   HOUSTON_API_TOKEN=your_token_here
   ```

2. Run Orbis using Docker:
   ```bash
   docker run --pull always --rm -it \
     --env-file .env \
     -v $(pwd)/output:/app/output \
     quay.io/astronomer/orbis:0.5.0 orbis compute-software \
     -s START_DATE \
     -e END_DATE \
     -o ORGANIZATION_ID \
     [-v] [-w WORKSPACES] [-z] [-r] [-p]
   ```

## Using Orbis CLI

> Check installation guide for Orbis CLI [here](../../installation#binary-installation)

1. Create a `.env` file with your configuration:
   ```env
   HOUSTON_API_TOKEN=your_token_here
   ```

2. Run Orbis using the Orbis CLI:
   ```bash
   orbis compute-software \
     -s START_DATE \
     -e END_DATE \
     -o ORGANIZATION_ID \
     [-v] [-w WORKSPACES] [-z] [-r] [-p]
   ```

## Command Options

<div class="command-options">
<table>
    <colgroup>
       <col style="width: 30%;">
       <col style="width: 70%;">
    </colgroup>
    <thead>
        <tr>
            <th>Option</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>-s, --start_date</code></td>
            <td>Start date for the report [format: YYYY-MM-DD]</td>
        </tr>
        <tr>
            <td><code>-e, --end_date</code></td>
            <td>End date for the report [format: YYYY-MM-DD]</td>
        </tr>
        <tr>
            <td><code>-o, --organization_id</code></td>
            <td>Astronomer organization domain</td>
        </tr>
        <tr>
            <td><code>-v, --verbose</code></td>
            <td>Enable verbose logging (use -v, -vv, or -vvv for more detailed logging) [Optional]</td>
        </tr>
        <tr>
            <td><code>-w, --workspaces</code></td>
            <td>Comma-separated list of Workspace IDs [optional]</td>
        </tr>
        <tr>
            <td><code>-z, --compress</code></td>
            <td>Compress the output reports [optional]</td>
        </tr>
        <tr>
            <td><code>-r, --resume</code></td>
            <td>Resume report generation from the last saved state [optional]</td>
        </tr>
        <tr>
            <td><code>-p, --persist</code></td>
            <td>Persist temporary files in output folder [optional]</td>
        </tr>
        <tr>
            <td><code>-u, --url</code></td>
            <td>Pre-signed URL (in quotes) to upload report [Optional]</td>
        </tr>
    </tbody>
</table>
</div>

## Example Usage

```bash
docker run --pull always --rm -it \
  --env-file .env \
  -v $(pwd)/output:/app/output \
  quay.io/astronomer/orbis:0.5.0 orbis compute-software \
  -s 2024-01-01 \
  -e 2024-01-31 \
  -o org-abcd1234 \
  -v
```

## Output

The command generates a detailed PDF report in the `output` directory with:

- CPU usage metrics
- Memory usage metrics
- Task success metrics
- Task processing trend
- Worker performance statistics