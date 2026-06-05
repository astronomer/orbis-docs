---
title: "Changelog"
slug: changelog
description: "Review notable Orbis changes by release."
hide-nav-links: true
hide-feedback: true
---

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.0] - 2026-06-05

### Added
* Added the `orbis reporting` command as the current reporting command path.
* Added Astro Private Cloud (APC) 1.x reporting support with Houston API version inference, retry behavior, non-admin token fallback, and per-data-plane Prometheus discovery.
* Added Control Plane (CP) and Data Plane (DP) scanner workflows for separated APC deployments.
* Added `--cp-namespace`, `--cp-kubeconfig`, indexed `--dpN-namespace`, and indexed `--dpN-kubeconfig` scanner options.
* Added Airflow namespace filters for DP scanner collection.
* Added session-based resume commands for incremental CP/DP collection:
  * `orbis resume list` shows sessions with status and cluster counts.
  * `orbis resume continue` retries failed or pending clusters and adds DPs with `--add-dp`.
  * `orbis resume merge` merges completed CP and DP artifacts into a single tar file.
* Added `--add-dp-cluster-id` to match discovered DPs by Houston cluster ID.
* Added automatic merge behavior when all clusters in a session complete.
* Added namespace validation and automatic Airflow namespace discovery for scanner collection.
* Added Podman-focused documentation for reporting, scanner create, scanner clean, and resume workflows.

### Changed
* Unified scanner execution into the main `quay.io/astronomer/orbis` image.
* Refreshed scanner Kubernetes resource handling, command flow, and support bundle naming for CP/DP sessions.
* Moved data collection scripts into the package layout and updated imports and tests.
* Improved report generation progress handling and DOCX output behavior.
* Improved Docker and Kubernetes kubeconfig resolution for scanner workflows.
* Raised the Ruff complexity threshold to 16 for orchestration-heavy code.

### Fixed
* Fixed Houston `rollbackEnabled` usage removed from the APC 2.x schema.
* Fixed scanner Kubernetes client usage so RBAC and job managers use the configured API client.
* Fixed scanner image issues for `click`, telescope virtual environment creation, kubeconfig paths, empty base domains, working folder restoration, and absolute tar paths.
* Fixed scanner subprocess safety and redacted authentication tokens from logs.
* Fixed scanner infrastructure setup, `/data` volume mounting, and fixed support bundle filename handling.
* Fixed multi-cluster scanner execution for discovered DPs without kubeconfig values.
* Fixed multi-architecture container image manifest generation in CI.
* Fixed data collector linting and formatting issues.

### Removed
* Removed the stale scanner-image test path from CI after scanner packaging changed.

## [0.8.0] - 2025-08-04

### Added
* **Scanner functionality**: New `orbis scanner` command for collecting diagnostic support bundles from Kubernetes clusters
* New `orbis-scanner` container image published on Quay.io with integrated diagnostic tools (kubectl, helm, astro-cli, telescope)
* Interactive YAML generation mode for infrastructure teams
* Support bundle creation with comprehensive cluster diagnostics
* Telescope integration for advanced Airflow diagnostics
* Python 3.13 support

!!! danger "Critical breaking change"
    Completely removed Astro Cloud support (`compute_astro` command and all related functionality). Orbis now focuses on Astro Private Cloud (formerly Astronomer Software).

### Changed
* Separated scanner functionality into dedicated `orbis-scanner` image
* Dropped Python 3.9 support, now requires Python 3.10+
* Updated project metadata to use 'astronomer-orbis' package name
* Major dependency updates: plotly 5.22→6.2, polars 1.14→1.31, click 8.1.7→8.2.1, pillow 10.4→11.3
* Replaced numpy with polars equivalents
* Improved CLI organization ID handling and error messages

### Fixed
* Comprehensive typing improvements and type hint accuracy throughout codebase
* Extensive linting fixes and code quality improvements
* Fixed task total calculations in report generation
* Various fixes for metrics collection and visualization
* Better error handling in CLI commands
* Base64 encoding implementation for secure tar file streaming from scanner pods
* Pod status validation now checks for running status instead of succeeded status for file operations

### Removed
* **Breaking**: All Astro-related functionality (astro_core.py, chronosphere.py, organization validation)
* Binary distribution support - no more binary builds
* Dependencies: numpy, sh
* Kaleido 1+ no longer includes bundled Chrome - Chrome/Chromium now required for local development (_Docker images include it_)

## [0.7.0] - 2025-03-05

### Fixed
* Fix kubernetes graphs by @indraneel07 in https://github.com/astronomer/orbis/pull/114
* Fix ke kpo formuals for pod count by @indraneel07 in https://github.com/astronomer/orbis/pull/115
* Fix missing celery pod graph from docx and minor fixes by @indraneel07 in https://github.com/astronomer/orbis/pull/116

### Added

### Changed

### Removed

## [0.6.1] - 2025-02-11

### Fixed
* 105 precision error while running report for astro by @abhishekbhakat in https://github.com/astronomer/orbis/pull/106

### Changed
* Orbis Test Driven Development on Astro by @abhishekbhakat in https://github.com/astronomer/orbis/pull/107
* 104 restructure generator for sizing estimation by @abhishekbhakat in https://github.com/astronomer/orbis/pull/109

### Removed

## [0.5.0] - 2024-12-09

### Added
* Added License by @indraneel07 in https://github.com/astronomer/orbis/pull/99
* 97 add aggregated successful and failure tasks count in csv and json by @abhishekbhakat in https://github.com/astronomer/orbis/pull/100

### Changed
* Improvements in orbis software by @indraneel07 in https://github.com/astronomer/orbis/pull/96
* Improvements in docs and submodule by @abhishekbhakat in https://github.com/astronomer/orbis/pull/102
* 0.5.0 preparation for docker-based usage by @abhishekbhakat in https://github.com/astronomer/orbis/pull/103

### Fixed
* Csv segementation fault while cython compile by @abhishekbhakat in https://github.com/astronomer/orbis/pull/101

### Removed

## [0.4.0] - 2024-10-21

### Added
- 44 prometheus client for software by [@indraneel07](https://github.com/indraneel07) in [#52](https://github.com/astronomer/orbis/pull/52)
- 53 reduce the size of docx report by [@abhishekbhakat](https://github.com/abhishekbhakat) in [#60](https://github.com/astronomer/orbis/pull/60)
- 70 add logging levels to orbis by [@indraneel07](https://github.com/indraneel07) in [#71](https://github.com/astronomer/orbis/pull/71)
- 19 add resume functionality by [@abhishekbhakat](https://github.com/abhishekbhakat) in [#79](https://github.com/astronomer/orbis/pull/79)
- 82 add workspace flag to consider only the workspaces for report generation software by [@indraneel07](https://github.com/indraneel07) in [#85](https://github.com/astronomer/orbis/pull/85)
- Reconvert to png from webp by [@indraneel07](https://github.com/indraneel07) in [#86](https://github.com/astronomer/orbis/pull/86)

### Changed
- 54 resource units handling custom AU by [@indraneel07](https://github.com/indraneel07) in [#57](https://github.com/astronomer/orbis/pull/57)
- 62 discussion separate commands for astro and software by [@abhishekbhakat](https://github.com/abhishekbhakat) in [#83](https://github.com/astronomer/orbis/pull/83)
- Separate dashboard urls prometheus for software & chronosphere for astro by [@indraneel07](https://github.com/indraneel07) in [#77](https://github.com/astronomer/orbis/pull/77)
- Multiline formatting for promQL queries in yaml by [@indraneel07](https://github.com/indraneel07) in [#78](https://github.com/astronomer/orbis/pull/78)

### Removed

### Fixed
- 56 & 58 handle missing token exception and local executor exclusion for software by [@indraneel07](https://github.com/indraneel07) in [#59](https://github.com/astronomer/orbis/pull/59)
- 63 remove images after report generation by [@indraneel07](https://github.com/indraneel07) in [#80](https://github.com/astronomer/orbis/pull/80)
- 69 pre signed url functionality by [@indraneel07](https://github.com/indraneel07) in [#84](https://github.com/astronomer/orbis/pull/84)
- Collect all reports and export as .zip by [@indraneel07](https://github.com/indraneel07) in [#68](https://github.com/astronomer/orbis/pull/68)

## [0.3.0] - 2024-08-07

### Added
- 42 orbis docs by [@abhishekbhakat](https://github.com/abhishekbhakat) in [#43](https://github.com/astronomer/orbis/pull/43)
- 41 houston api client by [@indraneel07](https://github.com/indraneel07) in [#47](https://github.com/astronomer/orbis/pull/47)
- 49 feature generate cluster level reports with orbis by [@indraneel07](https://github.com/indraneel07) in [#50](https://github.com/astronomer/orbis/pull/50)

### Changed
- extract worker_type from deployment queues instead of cluster for Hosted by [@indraneel07](https://github.com/indraneel07) in [#48](https://github.com/astronomer/orbis/pull/48)

## [0.2.1] - 2024-08-01

### Added
- JSON to have worker queue name for celery and k8s to not have worker queues by [@abhishekbhakat](https://github.com/abhishekbhakat) in [#26](https://github.com/astronomer/orbis/pull/26)
- Dropping singctl dependency by [@abhishekbhakat](https://github.com/abhishekbhakat) in [#29](https://github.com/astronomer/orbis/pull/29) and [#32](https://github.com/astronomer/orbis/pull/32)

### Changed
- Fix worker queues for celery queries. by [@akshaykumarsalunke](https://github.com/akshaykumarsalunke) in [#37](https://github.com/astronomer/orbis/pull/37)
- Deprecation of `orbis` root command and new command `orbis sizing` by [@abhishekbhakat](https://github.com/abhishekbhakat) in [#25](https://github.com/astronomer/orbis/pull/25)

### Removed

### New Contributors
- [@akshaykumarsalunke](https://github.com/akshaykumarsalunke) made their first contribution in [#37](https://github.com/astronomer/orbis/pull/37)

## [0.1.0] - 2024-07-08

### Added
- Orbis initial repo structuring and refactoring by [@indraneel07](https://github.com/indraneel07) in [https://github.com/astronomer/orbis/pull/18](https://github.com/astronomer/orbis/pull/18)

## [0.0.0] - Python Script

- It started as a simple script `report_generator.py` for generating deployment sizing reports to reduce human effort.

[0.9.0]: https://github.com/astronomer/orbis/compare/0.8.0...0.9.0
[0.8.0]: https://github.com/astronomer/orbis/compare/0.7.0...0.8.0
[0.7.0]: https://github.com/astronomer/orbis/compare/orbis-0.6.1...0.7.0
[0.6.1]: https://github.com/astronomer/orbis/compare/orbis-0.5.0...0.6.1
[0.5.0]: https://github.com/astronomer/orbis/compare/orbis-0.4.0...0.5.0
[0.4.0]: https://github.com/astronomer/orbis/compare/orbis-0.3.0...orbis-0.4.0
[0.3.0]: https://github.com/astronomer/orbis/compare/orbis-0.2.1...orbis-0.3.0
[0.2.1]: https://github.com/astronomer/orbis/compare/orbis-0.1.2...orbis-0.2.1
[0.1.0]: https://github.com/astronomer/orbis/tree/orbis-0.1.0
[0.0.0]: https://github.com/astronomer/orbis/tree/03c1fa02cd50f14ee2f4561dac262ff435db06a0
