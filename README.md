Welcome to my new dbt project!

### 1. Overview
This dbt project is a hands-on learning and experimentation environment 
focused on building, testing, and documenting analytics engineering workflows.
It covers core dbt concepts such as staging and mart layers, data quality tests, 
unit tests, metrics, semantic modeling, and CI-related practices, 
with an emphasis on correctness and maintainability. 

### 2. Data Warehouse Platforms
The project was initially implemented using a Snowflake connection 
and later migrated to BigQuery, allowing comparison of adapter-specific behaviors 
and best practices while reinforcing platform-agnostic dbt design principles.

### 3. Project Structure
The project includes:
- Staging Models: Raw data ingestion and transformation.
- Mart Models: Business logic and aggregations.
- Snapshots: Capturing historical data changes.
- Tests: Data quality and unit tests to ensure model reliability.
- Documentation: Comprehensive documentation for models and tests.
- Metrics: Definitions and calculations for key business metrics.
- Semantic Models: Enhanced data models for analytics.

### 4. CI/CD and Documentation
The project uses GitHub Actions for CI/CD workflows, including automated testing and automated documentation deployment.
The documentation is publicly hosted on GitHub Pages and can be accessed [here](https://araminho.github.io/dbt-core-test-project/).