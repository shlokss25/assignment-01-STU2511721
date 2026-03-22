\# Part 6 — Capstone Design Justification



\## Storage Systems



The hospital network has four distinct goals, each with different data access patterns, latency requirements, and data types. No single storage system is optimal for all four; a purpose-built hybrid architecture is required.



\*\*Goal 1 — Predict patient readmission risk (ML on historical treatment data)\*\*  

This workload is analytical and batch-oriented. Historical treatment records — diagnoses, procedures, medications, lab results, discharge summaries — are structured and semi-structured. The recommended storage system is a \*\*Data Lakehouse\*\* (e.g., Apache Iceberg on cloud object storage such as AWS S3, with a Spark or Databricks compute layer). The Lakehouse maintains a Bronze layer of raw EHR exports, a Silver layer of cleaned and joined feature tables, and a Gold layer of ML-ready feature vectors. Apache Iceberg provides ACID transactions, schema evolution, and time-travel — all necessary for reproducible model training across hospital system upgrades. The trained model artefacts are stored in an \*\*ML model registry\*\* (MLflow or SageMaker Model Registry).



\*\*Goal 2 — Allow doctors to query patient history in plain English (RAG system)\*\*  

This is a semantic search workload over unstructured clinical notes, discharge summaries, and medical reports. The recommended system is a \*\*Vector Database\*\* (e.g., Pinecone, Weaviate, or pgvector on PostgreSQL). Clinical documents are chunked, embedded using a medical language model (Bio-ClinicalBERT or MedPaLM), and stored as dense vectors. At query time, the doctor's natural language question is embedded and the top-k semantically similar document chunks are retrieved, then synthesised by an LLM (Retrieval-Augmented Generation). The source documents live in the Data Lake; the vector index is a derived, queryable layer on top.



\*\*Goal 3 — Generate monthly management reports (bed occupancy, department-wise costs)\*\*  

This is a classic OLAP workload requiring aggregation over structured, historical data. The recommended system is a \*\*Data Warehouse\*\* (e.g., Google BigQuery, Amazon Redshift, or Snowflake). The warehouse houses a star schema: a central `fact\_admissions` table with foreign keys to `dim\_department`, `dim\_ward`, `dim\_date`, and `dim\_procedure`. Monthly reports run as SQL queries with GROUP BY aggregations. The warehouse is populated nightly via an ETL pipeline from the operational OLTP database (see Goal 4 below).



\*\*Goal 4 — Stream and store real-time ICU vitals\*\*  

This is a high-velocity, time-series streaming workload. ICU monitors emit continuous readings (heart rate, SpO2, blood pressure, temperature) at sub-second intervals for every patient. The recommended system is a \*\*Time-Series Database\*\* (e.g., InfluxDB or TimescaleDB), fed by a streaming ingestion pipeline (Apache Kafka or AWS Kinesis). Kafka absorbs the real-time stream, decouples producers (ICU devices) from consumers (alerting systems, dashboards), and delivers data to both the time-series DB for real-time monitoring and the Data Lake for long-term storage and retrospective analysis.



\---



\## OLTP vs OLAP Boundary



The \*\*OLTP boundary\*\* is the operational Electronic Health Record (EHR) system — a relational database (PostgreSQL or MySQL) that handles day-to-day clinical transactions: registering admissions, recording prescriptions, updating vitals flags, scheduling procedures, processing insurance claims. This system is optimised for concurrent write throughput, low-latency single-record lookups, and strict ACID compliance. It serves nurses, doctors, and the billing department in real time.



The \*\*OLAP boundary begins at the ETL/ELT pipeline\*\* that extracts data from the EHR (and from Kafka for streaming vitals) and loads it into the Data Warehouse and Data Lake. This boundary is typically implemented as a nightly batch job (for historical reporting) supplemented by a micro-batch or streaming pipeline (for near-real-time dashboards). The Data Warehouse's star schema is read-only from the reporting perspective — hospital management and BI analysts query it with no write contention against the operational system.



The dividing line is clear: \*\*writes go to OLTP (EHR + Kafka); reads-for-analysis go to OLAP (Warehouse + Lakehouse)\*\*. The Kafka stream bridges the two for the ICU vitals goal, acting as the boundary where real-time data transitions from operational to analytical.



\---



\## Trade-offs



\*\*Identified Trade-off: Complexity and Operational Overhead of a Multi-System Architecture\*\*



The architecture proposed — EHR (PostgreSQL), Kafka, Data Lakehouse, Data Warehouse, Vector Database, Time-Series Database, and ML model registry — is powerful but introduces significant operational complexity. Each system requires separate infrastructure provisioning, monitoring, security patching, backup policies, and team expertise. A small hospital IT team may struggle to maintain six distinct storage systems simultaneously.



\*\*Mitigation Strategy:\*\*  

The primary mitigation is to adopt a \*\*managed cloud-native stack\*\* that reduces operational burden to configuration rather than infrastructure management. For example, on AWS: Amazon RDS (EHR), Amazon MSK (Managed Kafka), AWS Glue + S3 + Iceberg (Lakehouse), Amazon Redshift (Warehouse), Amazon OpenSearch with vector support (or pgvector on RDS), and Amazon Timestream (time-series). All services offer automated backups, scaling, and SLA-backed uptime without the hospital maintaining bare-metal infrastructure.



A secondary mitigation is \*\*phased implementation\*\*: start with the EHR (Goal 4 operational), then add the Warehouse for reporting (Goal 3), then layer the Lakehouse for ML (Goal 1), and finally add the Vector DB for NLP queries (Goal 2). This staggers the complexity curve and allows the team to build expertise incrementally rather than launching all six systems simultaneously.



A tertiary mitigation is \*\*consolidation where possible\*\*: PostgreSQL with the TimescaleDB extension can serve both the EHR (OLTP) and the time-series vitals store, reducing the total number of distinct systems from six to five until scale demands separation. Similarly, pgvector adds vector similarity search to the existing PostgreSQL instance without requiring a separate vector database deployment until query volume justifies it.



