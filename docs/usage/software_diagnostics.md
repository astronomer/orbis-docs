# Diagnostics for Astronomer Software

The `orbis scanner` command collects diagnostic information from Kubernetes clusters. This generates the **critical support bundle to share with Astronomer support team** when raising support cases.

## Overview

The scanner creates a comprehensive support bundle containing:

- Kubernetes cluster information
- Astronomer deployment details
- Logs and configurations
- Optional telescope data for advanced diagnostics

## Prerequisites

1. Kubernetes cluster access (kubectl configured)
2. Appropriate RBAC permissions for the scanner pod
3. Access to the orbis-scanner container image

## Scanner Commands

> Check installation guide for Orbis CLI [here](../../installation#binary-installation)

### scanner create
Creates and runs the diagnostic scanner.

```bash
orbis scanner create \
  -n NAMESPACE \
  --image quay.io/astronomer/orbis-scanner:0.8.0 \
  [OPTIONS]
```

**Required Options:**

- `-n, --namespace`: Namespace where Astronomer is installed
- `--image`: Scanner container image (must be accessible by the cluster)

**Optional Parameters:**

- `--interactive`: Generate YAML for manual application by infrastructure team
- `--output-file`: Output file for YAML generation
- `--domain`: Astronomer domain
- `-c, --cluster`: Cluster name identifier
- `--telescope`: Enable telescope data collection
- `--telescope-only`: Collect only telescope data and related helm info
- `--kubeconfig`: Path to kubeconfig file
- `--cpu`: CPU cores (default: 1)
- `--memory`: Memory in GiB (default: 1Gi)
- `--sleep`: Sleep time in seconds (default: 86400, minimum: 3600)
- `--cleanup / --no-cleanup`: Clean up resources after completion
- `--log-level`: Set logging level (warn|info|debug)
- `-v, --verbose`: Increase verbosity (use -v, -vv, or -vvv for more detailed logging)
- `--airflow-namespaces`: Specify additional namespaces to include
- `--all-airflow-namespaces`: Collect data from all namespaces in the cluster

### scanner retrieve
Retrieves data from an existing scanner pod.

```bash
orbis scanner retrieve -n NAMESPACE [OPTIONS]
```

**Options:**

- `-n, --namespace`: Namespace where Astronomer is installed (required)
- `--pod-name`: Specific pod name to retrieve from
- `--output-dir`: Directory to save the retrieved data (default: current directory)
- `--cleanup/--no-cleanup`: Clean up resources after retrieving (default: true)
- `-v, --verbose`: Increase verbosity (use -v, -vv, or -vvv for more detailed logging)
- `--kubeconfig`: Path to kubeconfig file

### scanner status
Checks the status of a running scanner job.

```bash
orbis scanner status -n NAMESPACE [OPTIONS]
```

**Options:**

- `-n, --namespace`: Namespace where Astronomer is installed (required)
- `-v, --verbose`: Increase verbosity (use -v, -vv, or -vvv for more detailed logging)
- `--kubeconfig`: Path to kubeconfig file

### scanner clean
Cleans up scanner resources.

```bash
orbis scanner clean -n NAMESPACE [OPTIONS]
```

**Resources cleaned up:**

- Scanner Job and associated Pods
- ServiceAccount (`temp-scanner-support-bundle`)
- ClusterRole (`read-support-bundle`)
- ClusterRoleBinding (`scanner-admin-access-binding`)

**Options:**

- `-n, --namespace`: Namespace where Astronomer is installed (required)
- `--dry-run`: Show kubectl commands that would be executed without running them
- `-v, --verbose`: Increase verbosity (use -v, -vv, or -vvv for more detailed logging)
- `--kubeconfig`: Path to kubeconfig file

## Usage Examples

**Direct execution (requires cluster admin access):**
```bash
orbis scanner create -n astronomer --image quay.io/astronomer/orbis-scanner:0.8.0 \
  --domain mycompany.astronomer.io -c prod-cluster
```

**With verbose logging for troubleshooting:**
```bash
orbis scanner create -n astronomer --image quay.io/astronomer/orbis-scanner:0.8.0 \
  --domain mycompany.astronomer.io -c prod-cluster -vv
```

**Generate YAML for infrastructure team:**
```bash
orbis scanner create -n astronomer --image quay.io/astronomer/orbis-scanner:0.8.0 \
  --interactive --output-file scanner-bundle.yaml
```

**Retrieve from existing pod with debug logging:**
```bash
orbis scanner retrieve -n astronomer --output-dir ./support-bundle -vvv
```

**Check scanner status with verbose output:**
```bash
orbis scanner status -n astronomer -v
```

**Show cleanup commands without executing them:**
```bash
orbis scanner clean -n astronomer --dry-run
```

## Logging and Troubleshooting

The scanner includes enhanced logging capabilities to help diagnose issues:

### Logging Levels
- **Default**: Info-level logging for normal operation
- **`-v`**: Warn-level logging (less verbose)
- **`-vv`**: Info-level logging (standard verbosity)
- **`-vvv`**: Debug-level logging (maximum verbosity)

### Log Files
Scanner operations create persistent log files in the output directory:

- Format: `scanner_{namespace}.log`
- Location: `./orbis_output/scanner_{namespace}/`
- Contains detailed operation logs for troubleshooting

### Troubleshooting Tips
- Use `-vv` or `-vvv` when experiencing issues with pod creation or data retrieval
- Log files persist after command completion for offline analysis
- Enhanced error reporting provides more context for Kubernetes operation failures
- File transfers now use base64 encoding for secure streaming of tar archives from scanner pods
- Pod operations now properly validate running status instead of succeeded status for file execution and copying

## Workflow

### Option 1: Direct Execution
1. Run `orbis scanner create` with required parameters
2. Scanner automatically creates Kubernetes resources (ServiceAccount, ClusterRole, ClusterRoleBinding, Job), collects data, and retrieves bundle
3. Support bundle is saved locally as `scanner-DD-MM-YY.tar.gz`
4. Resources are automatically cleaned up unless `--no-cleanup` is specified

### Option 2: Infrastructure Team Workflow
1. Generate YAML: `orbis scanner create --interactive --output-file scanner.yaml`
2. Share YAML with infrastructure team to apply: `kubectl apply -f scanner.yaml`
3. Retrieve data: `orbis scanner retrieve -n <namespace>`
4. Clean up: `orbis scanner clean -n <namespace>` (removes all created resources)

## Output

The scanner generates a compressed support bundle (`scanner-DD-MM-YY.tar.gz`) containing:

- Kubernetes resource manifests
- Pod logs and events
- Helm chart information
- Astronomer configuration details
- Optional telescope diagnostic data

**Share this bundle with Astronomer support for fastest issue resolution.**

## Tools Included

The scanner container includes these diagnostic tools:

- **[kubectl](https://kubernetes.io/docs/reference/kubectl/)**: Kubernetes cluster interaction
- **[helm](https://helm.sh/docs/)**: Helm chart information
- **[astro-cli](https://www.astronomer.io/docs/astro/cli/overview)**: Astronomer CLI tools
- **[telescope](https://astronomer.github.io/telescope/)**: Advanced Airflow diagnostics
