---
title: "Report command reference"
slug: report-cli-reference
description: "Review Orbis reporting command-line options and examples."
hide-nav-links: true
hide-feedback: true
---

# Report command reference

## reporting

Generate deployment compute reports for Astro Private Cloud (APC).

```bash
orbis reporting -s <start-date> -e <end-date> -b <base-domain> [OPTIONS]
```

### Options

| Option | Description | Required |
|---|---|---|
| `-s, --start_date` | Start date in UTC, in `YYYY-MM-DD` format. | Yes |
| `-e, --end_date` | End date in UTC, in `YYYY-MM-DD` format. The end date is not inclusive. | Yes |
| `-b, --base_domain` | APC platform base domain. | Yes |
| `--version` | APC cluster version, for example `1.1.0` or `2.0.0`. When omitted, Orbis auto-infers the version from the Houston API. | No |
| `-v, --verbose` | Increase verbosity (`-v`, `-vv`, `-vvv`). | No |
| `-w, --workspaces` | Comma-separated list of workspace IDs. | No |
| `-z, --compress` | Compress the output reports. | No |
| `-r, --resume` | Resume from the last saved state. | No |
| `-p, --persist` | Persist temporary files in the output folder. | No |
| `-u, --url` | Pre-signed URL, in quotes, to upload the report to. | No |

### Examples

Generate a report for all workspaces:

```bash
orbis reporting -s <start-date> -e <end-date> -b <base-domain>
```

Generate a report for specific workspaces and compress the output:

```bash
orbis reporting -s <start-date> -e <end-date> -b <base-domain> \
  -w <workspace1-id>,<workspace2-id> -z
```

Resume an interrupted report:

```bash
orbis reporting -s <start-date> -e <end-date> -b <base-domain> -r
```

### Report flow

1. Orbis validates the start date, end date, and base domain.
2. Orbis fetches organization metadata and deployment information from the Houston API.
3. Orbis queries Prometheus for metrics and renders visualizations.
4. Orbis writes DOCX, CSV, and JSON reports to the output folder.

## Debug in Visual Studio Code

Use this configuration in `.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python Debugger: Orbis",
            "type": "debugpy",
            "request": "launch",
            "module": "orbis.cli",
            "console": "integratedTerminal",
            "args": [
                "reporting",
                "-b",
                "<base-domain>",
                "--version",
                "<platform-version>",
                "-s",
                "<start-date>",
                "-e",
                "<end-date>"
            ]
        }
    ]
}
```
