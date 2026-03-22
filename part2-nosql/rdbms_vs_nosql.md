\# Part 2 — NoSQL Subjective



\## Database Recommendation



\*\*Scenario:\*\* A healthcare startup is building a patient management system. One engineer recommends MySQL; another recommends MongoDB. Given ACID vs BASE and the CAP theorem, which would you recommend? Would your answer change for a fraud detection module?



\---



\### Recommendation: MySQL (RDBMS) for the Core Patient Management System



For a patient management system, I would strongly recommend \*\*MySQL\*\* (or another ACID-compliant RDBMS like PostgreSQL), and here is the reasoning grounded in both theory and practice.



\*\*ACID vs BASE — Why ACID is Non-Negotiable Here\*\*



Healthcare data is among the most sensitive and legally regulated data in existence. When a doctor prescribes medication, updates a diagnosis, or records an allergy, that transaction must be \*\*Atomic\*\* (the entire update succeeds or nothing changes), \*\*Consistent\*\* (data never violates integrity constraints like foreign key references between patients and prescriptions), \*\*Isolated\*\* (two doctors updating the same patient record simultaneously must not cause a race condition), and \*\*Durable\*\* (a confirmed write survives a system crash). MongoDB, following the \*\*BASE\*\* model (Basically Available, Soft-state, Eventually consistent), was architecturally designed to trade consistency for availability — which is the exact wrong trade-off for a system where "patient is allergic to penicillin" must be instantly and absolutely consistent across all nodes. A stale read in an eventually-consistent system could cause a prescribing error with life-threatening consequences.



\*\*CAP Theorem — Consistency over Availability\*\*



Under the CAP theorem, MongoDB prioritizes \*\*Availability and Partition tolerance (AP)\*\* in its default configuration. A patient management system should prioritize \*\*Consistency and Partition tolerance (CP)\*\*. MySQL with synchronous replication enforces CP guarantees — when the network partitions, the system refuses stale reads rather than serving potentially incorrect data.



\*\*Schema Enforcement as a Safety Net\*\*



Patient records have well-defined, regulatory-mandated structures (HL7 FHIR standards, for instance). MySQL's rigid schema prevents invalid data entry — a field for "blood\_type" cannot accidentally receive a numeric value. MongoDB's schema-less nature introduces risk of data corruption through application bugs.



\---



\### Would the Answer Change for a Fraud Detection Module?



\*\*Yes — significantly.\*\* A fraud detection module has fundamentally different requirements: it ingests high-velocity event streams (payment attempts, login patterns), queries across massive, unstructured behavioral logs, and needs to run graph-like similarity queries (is this IP linked to flagged accounts?). These workloads are read-heavy, analytically oriented, and tolerate eventual consistency.



For fraud detection, I would recommend a \*\*hybrid architecture\*\*: MongoDB or Apache Cassandra for the raw event log ingestion (high write throughput, horizontal scalability), combined with a \*\*graph database like Neo4j\*\* for relationship traversal (detecting fraud rings), and potentially a \*\*vector database\*\* for anomaly detection using embedding similarity. ACID guarantees are less critical here because the cost of a false negative (missing a fraud signal by a few milliseconds) is lower than the cost of blocking a legitimate patient care transaction. This is a textbook case where BASE and AP systems shine.



\*\*In summary:\*\* MySQL for the core patient system (ACID, CP, strict schema), and a purpose-built analytics or NoSQL stack for the fraud detection module.



