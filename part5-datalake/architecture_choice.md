# Part 5 — Data Lake Architecture

## Architecture Recommendation

**Scenario:** A fast-growing food delivery startup collects GPS location logs, customer text reviews, payment transactions, and restaurant menu images. Which storage architecture would you recommend — Data Warehouse, Data Lake, or Data Lakehouse?

---

### Recommendation: Data Lakehouse

I would recommend a **Data Lakehouse** architecture for this startup, and here are three specific reasons grounded in the nature of their data.

**Reason 1 — Heterogeneous, Multi-Modal Data Makes a Pure Data Warehouse Insufficient**

A traditional Data Warehouse (e.g., Snowflake, BigQuery in warehouse mode, Redshift) is designed for structured, pre-modelled tabular data. It handles payment transactions beautifully but is fundamentally ill-suited for GPS location logs (semi-structured time-series streams), customer text reviews (unstructured NLP text), and restaurant menu images (binary blobs). Forcing all four data types into a warehouse schema would require extreme preprocessing that destroys raw data fidelity and makes it impossible to run future workloads (e.g., training a sentiment model on raw review text). A Data Lakehouse stores all four data types natively — structured (payments), semi-structured (GPS JSON logs), unstructured (reviews, images) — without discarding the raw form.

**Reason 2 — A Pure Data Lake Lacks the Governance and Query Performance Needed for Reporting**

A traditional Data Lake (raw files on S3 or GCS) solves the storage problem but introduces new problems: no schema enforcement, no ACID transactions, no indexing, and poor query performance for BI reports. If the analytics team queries "average delivery time per city last month," a scan over millions of raw GPS JSON files without partitioning or indexing would be unacceptably slow. The Data Lakehouse addresses this by adding an open table format layer (Apache Iceberg, Delta Lake, or Apache Hudi) on top of cheap object storage. This layer provides ACID transactions, time-travel, Z-ordering, and partition pruning — making analytical queries fast without sacrificing the schema flexibility of a Data Lake.

**Reason 3 — AI/ML Workloads Require Raw Data Access That a Warehouse Cannot Provide**

The startup will inevitably want to build AI models — a restaurant image classifier (for menu quality), a delivery time predictor (from GPS logs), and a review sentiment analyser. These models need raw, unprocessed data: original GPS coordinates, untruncated review text, full-resolution images. A Data Warehouse would have already aggregated and filtered this data beyond usability for ML training. A Data Lakehouse maintains the raw Bronze layer (untouched ingestion), a Silver layer (cleaned and joined), and a Gold layer (aggregated for BI) — the multi-hop architecture. ML pipelines train on Silver, BI reports run on Gold, and raw data is always recoverable from Bronze.

**Conclusion:** The Data Lakehouse (implemented on, e.g., Databricks Lakehouse or AWS Lake Formation + Iceberg) is the only architecture that handles all four data types, supports both real-time BI reporting and ML workloads, enforces governance, and scales cost-effectively with a growing startup.
