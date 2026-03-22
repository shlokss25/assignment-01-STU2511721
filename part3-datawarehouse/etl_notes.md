# Part 3 — ETL Notes

## ETL Decisions

### Decision 1 — Date Format Standardisation

**Problem:**  
The `date` column in `retail_transactions.csv` contains three distinct formats across rows:
- ISO format: `2023-02-05` (e.g., TXN5002)
- DD/MM/YYYY: `29/08/2023` (e.g., TXN5000)
- DD-MM-YYYY: `12-12-2023` (e.g., TXN5001)

If loaded directly into the warehouse, a `DATE` column would reject the non-ISO strings and either error out or silently store `NULL` depending on the database's strictness setting. Queries filtering by date range (e.g., "all transactions in Q3") would return incorrect results if some rows have NULL dates.

**Resolution:**  
Before loading, all date values were parsed using Python's `dateutil.parser.parse()` which handles all three formats automatically. The parsed `datetime` object was then serialised to a canonical `YYYY-MM-DD` ISO 8601 string before insertion. In the `dim_date` table, dates are also stored as integer surrogate keys in `YYYYMMDD` format (e.g., `20230829`) to enable fast integer joins instead of string or date comparisons. Every fact row's `date_key` references a pre-computed row in `dim_date`.

---

### Decision 2 — Category Casing Standardisation

**Problem:**  
The `category` column contains inconsistent casing across rows:
- `Electronics` (correct Title Case) — appears in some rows
- `electronics` (all lowercase) — appears in rows for products like Speaker, Smartwatch, Speaker
- `Groceries` (plural) — appears for Milk, Biscuits
- `Grocery` (singular) — appears for Atta, Rice, Oil, Pulses

This inconsistency means a simple `GROUP BY category` query would return four groups instead of three, splitting totals incorrectly. A report showing "Total sales by category" would show separate lines for `electronics` and `Electronics`, massively undercounting each.

**Resolution:**  
A normalisation mapping was applied during transformation:
- `electronics` → `Electronics` (uppercase first letter)
- `Groceries` → `Grocery` (standardise to singular, consistent with non-food-service conventions)
- `Clothing` and `Furniture` required no change

This mapping was implemented as a Python dictionary lookup applied to every row before loading into `dim_product`. The `dim_product` table now has a `CHECK` constraint-friendly set of values, and all analytical queries group correctly.

---

### Decision 3 — NULL Store City Imputation

**Problem:**  
Several rows in `retail_transactions.csv` have `NULL` (blank) values in the `store_city` column. For example:
- TXN5033: `store_name = 'Mumbai Central'`, `store_city = NULL`
- TXN5044: `store_name = 'Chennai Anna'`,   `store_city = NULL`
- TXN5082: `store_name = 'Delhi South'`,    `store_city = NULL`

If loaded as-is, queries like "Top 2 stores by city" or dimensional rollups by `store_city` would either exclude these transactions entirely (with a `WHERE store_city IS NOT NULL` filter) or produce a separate `NULL` grouping that distorts reporting.

**Resolution:**  
Since `store_name` uniquely identifies the city (each store name contains a consistent city prefix — e.g., all `Mumbai Central` records belong to Mumbai), a deterministic imputation was applied: the city was inferred from the store name using a lookup table constructed from non-NULL rows:

| store_name       | imputed_city |
|------------------|--------------|
| Chennai Anna     | Chennai      |
| Bangalore MG     | Bangalore    |
| Mumbai Central   | Mumbai       |
| Delhi South      | Delhi        |
| Pune FC Road     | Pune         |

This imputation is deterministic and documented, making it auditable and reproducible. The `dim_store` table stores the cleaned city values, so all fact rows join correctly regardless of the original NULL.
