# Report Generator

The Report Generator module is responsible for creating comprehensive deployment compute reports. It consists of two main components: the `generate_report` function and the `ReportGenerator` class.

## generate_report Function

This function orchestrates the entire report generation process:

1. Fetches data from Chronosphere for specified metrics and namespaces using `get_data_from_chronosphere_and_plot`.
2. Processes data and generates visualizations (figures) for each metric.
3. Creates an overall report structure containing detailed information for each namespace.
4. Generates a Word document report using the `ReportGenerator` class.
5. Exports the report data to JSON and CSV formats using `json.dump` and `generate_csv_from_report` respectively.

## ReportGenerator Class

This class handles the creation and formatting of the Word document report:

1. `setup_document`: Sets up the document structure with proper margins and headers/footers.
2. `add_title_page`: Creates a title page with report metadata.
3. `add_figure`: Adds figures (charts) to the document.
4. `add_statistics_table`: Includes statistics tables for each metric.
5. `add_visualization_url`: Adds URLs for each query.
6. `save_document`: Saves the formatted document.

The `ReportGenerator` class allows the `generate_report` function to focus on data processing and overall report structure, while delegating the specifics of document creation to this specialized class. This separation of concerns enhances modularity and maintainability of the code.
