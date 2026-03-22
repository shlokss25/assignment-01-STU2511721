\# Part 1 — Normalization



\## Anomaly Analysis



\### Insert Anomaly



\*\*Definition:\*\* An insert anomaly occurs when you cannot add new data to the database without also adding other unrelated data, or when adding data forces duplication.



\*\*Example from `orders\_flat.csv`:\*\*



Suppose the company hires a new Sales Representative \*\*SR04 — Meera Kapoor\*\* (`meera@corp.com`), based in the Kolkata Office. Because the `office\_address` and `sales\_rep\_email` are stored only alongside an order, \*\*we cannot record SR04's details until she places at least one order in the system.\*\* There is no separate place to store a sales rep without an associated order.



Similarly, if a new product \*\*P009 — Whiteboard Marker\*\* (Stationery, ₹80) is added to the catalog, it cannot be recorded in the flat file until it is actually ordered.  

→ This is confirmed by noting that no row exists for such a product — inserting it would require a dummy or partial order row.



\---



\### Update Anomaly



\*\*Definition:\*\* An update anomaly occurs when a single logical change requires multiple rows to be updated, creating the risk of inconsistency.



\*\*Example from `orders\_flat.csv`:\*\*



Sales Representative \*\*SR01 — Deepak Joshi\*\* appears in many rows (e.g., rows for ORD1114, ORD1153, ORD1091, ORD1022, etc.). His office address is stored as `Mumbai HQ, Nariman Point, Mumbai - 400021` across most rows, but in several rows (e.g., ORD1180, ORD1173, ORD1170, ORD1172, ORD1176, ORD1177, ORD1182, ORD1183, ORD1184) the address is recorded as `Mumbai HQ, Nariman Pt, Mumbai - 400021` — an abbreviated inconsistent form.



If Deepak Joshi's office address changes, \*\*every single row\*\* associated with SR01 must be updated. If even one row is missed, the data becomes inconsistent. This is a classic update anomaly — the address is a fact about the sales rep, not about the order.



\---



\### Delete Anomaly



\*\*Definition:\*\* A delete anomaly occurs when deleting a row to remove one piece of information inadvertently destroys other unrelated information.



\*\*Example from `orders\_flat.csv`:\*\*



Customer \*\*C007 — Arjun Nair\*\* (`arjun@gmail.com`, Bangalore) is associated with multiple orders including order \*\*ORD1145\*\* (row index 153), which is for \*\*P004 — Notebook\*\* placed with SR03.



If all orders by Arjun Nair were to be deleted (e.g., the company removes his account and order history), \*\*we would also lose the fact that Arjun Nair exists as a customer\*\* — his email, city, and customer ID would be gone entirely since they are only recorded within order rows. There is no standalone customer table to retain his record.



More critically: if \*\*ORD1093\*\* (the only order from Arjun Nair for `Standing Desk` with SR03) were deleted, that specific combination of customer–product knowledge would be erased — demonstrating that deleting an order deletes customer/product information.



\---



\## Normalization Justification



\*\*"Your manager argues that keeping everything in one table is simpler and normalization is over-engineering. Using specific examples from the dataset, defend or refute this position."\*\*



The argument that a single flat table is "simpler" is appealing at first glance but collapses under real-world data conditions. The `orders\_flat.csv` dataset is a perfect illustration of why normalization is not over-engineering but rather a business necessity.



First, consider data integrity. Sales representative \*\*Deepak Joshi (SR01)\*\* appears in dozens of rows, yet his office address is recorded inconsistently — sometimes as `Mumbai HQ, Nariman Point` and sometimes as `Mumbai HQ, Nariman Pt`. In a normalized schema, the address is stored once in a `sales\_reps` table; updating it is a single-row operation with zero risk of inconsistency. In the flat file, it requires hunting and updating potentially 60+ rows, and even then, human error leaves the address divergent across rows — exactly what we observed in the data.



Second, consider storage and redundancy. Customer \*\*Neha Gupta (C006)\*\* has approximately 20 orders. Her name, email, and city (`neha@gmail.com`, Delhi) are repeated in every single row. This is pure redundancy. In a normalized design with a `customers` table, her data is stored exactly once. For a dataset with hundreds of thousands of customers, this redundancy becomes a storage and maintenance problem at scale.



Third, consider the inability to represent real-world entities independently. The flat file cannot record a new product, a new sales rep, or a new customer until an order is placed — a direct insert anomaly. Businesses frequently need to onboard products and representatives before any sales occur. A normalized schema with dedicated `products`, `customers`, and `sales\_reps` tables eliminates this constraint.



Finally, queries become more accurate. In the flat file, a query to find "all customers" might inadvertently double-count if customers appear in multiple rows. In a normalized schema, the answer is always one row per customer.



Normalization is not over-engineering. It is the minimum viable structure for a data model that remains correct, consistent, and maintainable as the business grows.



