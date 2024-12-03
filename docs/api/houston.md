# Houston API Integration

The `houston.py` module integrates with the [Houston API](https://www.astronomer.io/docs/software/houston-api) to retrieve deployment information from Astronomer Software. This module gathers metadata about organizations, workspaces, and deployments for metric collection.

## Key Components

### API Class

The Houston API class handles:

- Authentication and request headers
- Methods for various API endpoints (deployments, organization, workspaces)
- Error handling and response validation

### Core Functionality

The module provides these key functions:

- `get_organization_metadata`: Retrieves organization details and namespaces
- `get_cluster_wise_deployments`: Groups deployments by clusters
- `get_deployment_wise_queues`: Fetches worker queue information for deployments

## Resource Management

### Resource Allocation

Software deployments support flexible resource allocation:

- Custom resource configurations
- Astronomer Units (AU) based allocation
- Dynamic scaling based on workload

### Resource Metrics

The API collects these resource metrics:

- Worker count (min/max replicas)
- Worker concurrency settings
- CPU and memory allocation
- Queue configurations and limits

### Resource Conversion

Since Software supports custom resource allocation:

- Resources are normalized for comparison
- Actual utilization is compared against allocated resources
- Both custom resources and AU configurations are supported

## Data Collection

The module collects data at the following levels:

1. Organization Level :
    - Deployment listings
    - Organization metadata
    - Namespace information

2. Workspace Level :
    - Workspace details
    - Deployment groupings

3. Deployment Level :
    - Executor configurations
    - Scheduler settings
    - Worker queue details
    - Resource allocations
