# Visualizer and Data Transformation

The Visualizer module in Orbis is responsible for creating high-quality, informative graphs from metric data. It works in tandem with advanced data transformation techniques to ensure optimal visualization even for large datasets.

## Visualizer Class

The Visualizer class is the core component for generating graphs:

### Key Features:
- Creates separate folders for each organization and namespace
- Generates graphs using Plotly
- Supports multiple data series on a single graph
- Calculates and displays statistical measures (mean, median)
- Customizes y-axis labels based on metric type
- Implements adaptive downsampling for large datasets

### Main Methods:
- `generate_graph`: Creates a graph for a given metric and set of dataframes
- `get_y_axis_label`: Determines appropriate y-axis label based on metric type
- `update_layout`: Customizes the graph layout for optimal readability

## Adaptive Downsampling

The adaptive downsampling technique, implemented in `transform.py`, is a powerful feature that allows Orbis to handle extremely large datasets efficiently:

### How it works:
1. Divides the data into windows of a specified size
2. Calculates the rate of change within each window
3. If the rate of change exceeds a threshold, all points in the window are kept
4. If the rate of change is below the threshold, only the mean value is kept
5. Adjusts the threshold dynamically to ensure the final dataset size is manageable

### Benefits:
- Preserves important data fluctuations
- Significantly reduces dataset size for faster rendering
- Maintains visual accuracy of the graph

## Integration

The Visualizer class seamlessly integrates the adaptive downsampling technique:

1. It checks if the dataset size exceeds a threshold (3,500,000 rows)
2. If so, it calls the `adaptive_downsample` function
3. The downsampled data is then used to create the graph

This integration ensures that Orbis can handle datasets of any size while still producing clear, informative visualizations. The combination of the Visualizer class and adaptive downsampling makes Orbis a powerful tool for analyzing and presenting complex metric data.
