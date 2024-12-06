# Data Models for Metrics

The data models in `models.py` are designed with a strong focus on metrics, allowing for efficient storage and manipulation of various deployment metrics. These models provide a structured way to represent and work with metric data throughout the Orbis system.

## Metric-Focused Design

1. **Metric Class**: This is the core model for representing individual metrics. It includes:
    - Metric identifier and name
    - Associated queries
    - Aggregators and table headers
    - Worker queue information
    - Executor type

2. **MetricCalculation Class**: Represents calculated values for a specific metric, including:
    - Mean, median, max, min, and 90th percentile values
    - Optional worker queue statistics

3. **WorkerQueueStats Class**: Stores detailed statistics for individual worker queues, allowing for granular analysis of queue performance.

4. **Figure Class**: Represents a generated visualization of a metric, linking the metric data with its visual representation.

5. **NamespaceReport and OverallReport Classes**: These classes aggregate metric calculations for namespaces and the entire organization, respectively.

## Flexibility for New Metrics

Adding new metrics to the system is relatively straightforward:

1. **YAML Configuration**: Add the new metric queries to the YAML configuration file.

2. **Model Updates**: In most cases, no changes to the existing models are required. The `Metric` class is designed to accommodate various types of metrics.

3. **Processing Logic**: Update the processing logic in `generator.py` and `csv_generator.py` to handle the new metric if it requires special treatment.

## Extensibility

The current model structure allows for easy extension:

1. **New Attributes**: If a new metric requires additional attributes, they can be added to the `Metric` or `MetricCalculation` classes.

2. **New Models**: For entirely new types of metrics or data, new dataclasses can be created following the existing pattern.

3. **Inheritance**: The existing classes can be extended through inheritance if more specialized metric types are needed.

This metric-focused design ensures that Orbis can efficiently handle a wide range of metrics while remaining flexible for future additions and changes.
