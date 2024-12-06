# Houston API Integration

The `houston.py` module is a crucial component of Orbis, leveraging the [Houston API](https://www.astronomer.io/docs/software/houston-api) to retrieve essential deployment information. This module provides a comprehensive interface to gather metadata about an organization, its workspaces and deployments, which is fundamental for targeted metric collection.

## Key Components

### API Class

This class encapsulates all interactions with the [Houston API](https://www.astronomer.io/docs/software/houston-api):

- Handles authentication and request headers
- Provides methods for various API endpoints (deployments, organization, workspaces)
- Implements error handling and response validation

### Utility Functions

Several utility functions build upon the CoreAPI class to provide higher-level functionality:

- `get_organization_metadata`: Retrieves organization name and associated namespaces
- `get_cluster_wise_deployments`: Groups deployments by clusters
- `get_deployment_wise_queues`: Fetches detailed information about worker queues for each deployment

## Leveraging Astro API for Deployment Data

The module efficiently utilizes the Astro API to gather comprehensive deployment information:

1. **Organization-Level Data**:
    - Retrieves all deployments associated with an organization
    - Fetches organization metadata
    - Retrieves a list of all namespaces within the organization
    - Obtains workspace details for an organization
    - Groups deployments by their associated worksapces
    - Gathers detailed metadata for each deployment
    - Extracts information about executor type, scheduler configuration, and worker queues
    - Includes information like queue names, worker types, concurrency, and scaling limits

## Why resource conversion is needed in Software

> As software does not have fixed size machines and has custom resource allocator (which can be either completely custom resources or Astronomer units), orbis fetches them to provide an idea of the component sizes as compared to resource utilization. Some deployments may have ample resources allocated but utilizing only a fraction of it.

## Computing resources for Software

- Maximum Worker count: replicas
- Minimum Worker count: 1 (Defaulted)
- Worker Concurrency: From Environment Variable, if not set, default to 16
> `Note:` If environment variable is set with Dockerfile, this will not be considered.
- Worker Type: Allocated worker limit resources

## Formulas to convert custom resources to AUs:

- Memory: resources["memory"] / 384
- CPU: resources["cpu"] / 100

- If AU conversion possible, then AUs = any(Memory in AUs, CPU in AUs)
- If AU conversion not possible, then AUs = [Memory in GB, CPU in vCPU]
> `Note:` AU conversion possible if the memory is in multiples of 384 and CPU is in multiples of 100 and both are same values.

## Integration with Orbis Workflow

This module plays a vital role in Orbis's operation:

1. It provides the necessary context for metric collection, ensuring that Orbis targets the correct deployments and namespaces.
2. The deployment configurations retrieved are used to populate the `DeploymentConfig` and `WorkerQueueStats` models.
3. This information guides the metric collection process in `prometheus.py` and the report generation in `generator.py`.

By leveraging the [Houston API](https://www.astronomer.io/docs/software/houston-api), Orbis can dynamically adapt to the current state of an organization's Software deployments, ensuring accurate and relevant metric collection and reporting.
