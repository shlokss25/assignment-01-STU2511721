\# Part 6 — Capstone Project



\## Introduction



The objective of this capstone section is to demonstrate how different modern data management technologies can be integrated to build a complete data ecosystem. Throughout this assignment, multiple data storage and processing approaches were explored, including relational databases, NoSQL databases, data warehouses, vector databases, and data lakes.



Each of these technologies serves a specific purpose within modern data-driven systems. By combining these components, organizations can efficiently store, process, and analyze large volumes of data.



\---



\## System Overview



The project demonstrates a simplified data architecture for managing and analyzing retail order data. The architecture includes multiple layers, each responsible for a specific data management task.



The components implemented in this assignment include:



\* \*\*Relational Database (RDBMS)\*\*

&#x20; Used for storing structured transactional data using SQL tables and relationships.



\* \*\*NoSQL Document Database\*\*

&#x20; Used for flexible storage of JSON-based order documents.



\* \*\*Data Warehouse\*\*

&#x20; Designed using a star schema to support analytical queries and business intelligence reporting.



\* \*\*Vector Database\*\*

&#x20; Demonstrates similarity search using vector embeddings to retrieve the most relevant items based on semantic similarity.



\* \*\*Data Lake\*\*

&#x20; Stores raw data in its original format and enables large-scale data analysis using processing tools such as Python.



\---



\## Data Architecture Flow



The overall data workflow can be described as follows:



1\. Transactional retail data is initially stored in a relational database.

2\. The same data can be stored in a NoSQL document format for flexible querying.

3\. Data is transformed and organized into a star schema within the data warehouse to support analytical queries.

4\. Vector embeddings can be generated from the data to enable semantic similarity search in a vector database.

5\. Raw datasets are stored in a data lake where large-scale processing and analytics can be performed.



This layered architecture reflects how modern organizations manage data across different storage and processing systems.



\---



\## Key Learnings



Through this assignment, several important concepts were explored:



\* Designing relational database schemas using SQL

\* Working with document-based NoSQL databases

\* Building analytical data models using star schemas

\* Understanding vector embeddings and similarity search

\* Processing raw data stored in a data lake



These technologies collectively form the foundation of modern data engineering systems.



\---



\## Conclusion



This capstone project demonstrates how multiple data management technologies can work together within a unified data architecture. By combining relational databases, NoSQL systems, data warehouses, vector databases, and data lakes, organizations can build scalable and flexible platforms for managing and analyzing large datasets.



The implementation of these components provides a practical understanding of modern data engineering concepts and highlights the importance of selecting the appropriate technology for different data processing needs.



