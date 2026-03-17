## ETL Decisions

### Decision 1 — Standardizing Date Formats

Problem: The raw dataset contained inconsistent date formats such as `DD-MM-YYYY`, `MM/DD/YYYY`, and some incomplete values. This created issues while joining with the date dimension and performing time-based analysis.

Resolution: All date values were converted into a standardized `YYYY-MM-DD` format before loading into the `dim_date` table. Invalid or incomplete dates were either corrected where possible or removed to maintain consistency. This ensured smooth joins and accurate month-wise and year-wise analysis.

### Decision 2 — Handling Missing and NULL Values

Problem: Some records in the dataset had NULL or missing values in important fields such as product category, total amount, and quantity. These missing values could lead to incorrect aggregations and unreliable insights.

Resolution: Missing numerical values like quantity and total amount were either filled using logical defaults or excluded if they were not recoverable. For categorical fields like product category, standardized default values were assigned where appropriate. This ensured that the dataset remained consistent and suitable for analytical queries.

### Decision 3 — Standardizing Category Naming

Problem: The product category field had inconsistent casing and naming variations such as “electronics”, “Electronics”, and “ELECTRONICS”. This would result in incorrect grouping during analysis, leading to fragmented results.

Resolution: All category values were standardized to a consistent format (e.g., “Electronics”, “Fashion”). This was done during the transformation stage before loading into the `dim_product` table. As a result, aggregation queries now produce accurate and meaningful category-level insights.
