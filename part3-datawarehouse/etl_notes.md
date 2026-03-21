## ETL Decisions

### Decision 1 — Standardizing Date Formats  
Problem: The dataset had different date formats like DD-MM-YYYY, MM/DD/YYYY, and some incomplete values. This made it difficult to join with the date table and perform time-based analysis properly.  

Resolution: All dates were converted into a single format (YYYY-MM-DD) before loading into the dim_date table. Invalid or incomplete dates were removed if they couldn’t be fixed. This helped in getting correct results for monthly and yearly analysis.


### Decision 2 — Handling Missing and NULL Values  
Problem: Some fields had missing or NULL values, especially in columns like category, quantity, and total amount. This could affect calculations and give incorrect results.  

Resolution: For numerical fields like quantity and total amount, I either filled reasonable default values or ignored those records if the data was not usable. For categorical fields, I assigned standard values where possible. This made the dataset cleaner and more reliable for analysis.


### Decision 3 — Standardizing Category Naming  
Problem: The category column had inconsistent naming like “electronics”, “Electronics”, and “ELECTRONICS”. This caused issues during grouping because they were treated as different values.  

Resolution: All category values were converted into a consistent format (for example, “Electronics”, “Fashion”) before loading into the dim_product table. This ensured that aggregation queries produced correct and meaningful results.