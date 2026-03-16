\# Part 3 — Data Warehouse Design (Star Schema)



\## Introduction



Modern organizations generate large volumes of transactional data from multiple operational systems. To analyze this data effectively for reporting and decision-making, a \*\*Data Warehouse\*\* is commonly used. A data warehouse is designed to support analytical queries rather than day-to-day transactions.



In this part of the assignment, a \*\*Star Schema\*\* was designed to organize the retail order dataset (`orders\_flat.csv`) into a structure suitable for analytical processing.



\---



\## Concept of a Star Schema



A \*\*Star Schema\*\* is one of the most widely used data warehouse designs. It consists of:



\* \*\*Fact Table\*\* — stores measurable transactional data

\* \*\*Dimension Tables\*\* — store descriptive attributes related to the facts



The structure resembles a star shape where the fact table is located at the center and dimension tables surround it.



This design simplifies complex analytical queries and improves query performance in large datasets.



\---



\## Schema Design



For the given dataset, the following tables were designed.



\### 1. Fact Table



\*\*FactOrders\*\*



This table stores the core transactional data of the retail orders.



Attributes included:



\* order\_id

\* customer\_id

\* product\_id

\* date\_id

\* status\_id

\* quantity

\* total\_amount



Each record represents a single order transaction.



\---



\### 2. Dimension Tables



The following dimension tables were created to describe the data in the fact table.



\*\*DimCustomer\*\*



Stores customer related information.



\* customer\_id

\* customer\_name



\---



\*\*DimProduct\*\*



Stores product details.



\* product\_id

\* product\_name

\* category



\---



\*\*DimDate\*\*



Stores date related information used for time-based analysis.



\* date\_id

\* year

\* month

\* day



\---



\*\*DimStatus\*\*



Stores order status information.



\* status\_id

\* status\_name



\---



\## Benefits of the Star Schema



Designing the data warehouse using a star schema provides several advantages:



\* Simplifies complex analytical queries

\* Improves performance of aggregation queries

\* Makes data easier to understand

\* Supports business intelligence reporting

\* Enables efficient filtering by dimensions such as product, customer, or date



\---



\## Conclusion



In this section of the assignment, a \*\*data warehouse schema\*\* was designed to transform the retail order dataset into an analytical model. By separating transactional measures into a fact table and descriptive information into dimension tables, the star schema provides an efficient structure for large-scale data analysis and reporting.



