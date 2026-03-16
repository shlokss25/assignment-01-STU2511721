\# Part 1 — Relational Database Design (RDBMS)



\## Introduction



In this part of the assignment, the objective is to analyze a flat transactional dataset and redesign it using principles of relational database normalization. Flat datasets often contain redundant information, which leads to data anomalies and inconsistency. To address these issues, the data is reorganized into multiple related tables following the Third Normal Form (3NF).



The redesigned schema separates entities such as customers, products, and orders into distinct tables. This improves data integrity, eliminates redundancy, and ensures efficient data management.



\---



\## Identified Data Anomalies



\### Insert Anomaly



An insert anomaly occurs when new information cannot be added to the database without the presence of other related data. In a flat table structure where customer, product, and order information are stored together, it becomes impossible to insert a new product unless an order already exists for that product.



For example, if a new product is introduced but has not yet been purchased, the database structure would not allow the product to be stored independently. By separating product information into a dedicated \*\*Products\*\* table, new products can be inserted without requiring an associated order.



\---



\### Update Anomaly



An update anomaly occurs when the same data appears in multiple rows and must be updated in several places. If product price information is stored repeatedly across many rows in a flat dataset, updating the price requires modifying every instance of that product.



If even one row is not updated correctly, the database becomes inconsistent. By storing product information in a single \*\*Products\*\* table, the price only needs to be updated once, ensuring consistency throughout the database.



\---



\### Delete Anomaly



A delete anomaly occurs when deleting a record unintentionally removes additional important data. In a flat table design, deleting an order record may also remove the only stored information about a product or customer.



For instance, if a product appears in only one order and that order is deleted, all information about that product may be lost. By separating entities into \*\*Customers\*\*, \*\*Products\*\*, \*\*Orders\*\*, and \*\*Order\_Items\*\*, deleting an order does not remove the associated product or customer information.



\---



\## Normalized Database Schema (3NF)



To resolve these anomalies, the dataset was normalized into four relational tables:



\* \*\*Customers\*\* – Stores customer information.

\* \*\*Products\*\* – Stores product details and pricing.

\* \*\*Orders\*\* – Records customer orders.

\* \*\*Order\_Items\*\* – Stores individual items within each order.



This structure follows the principles of \*\*Third Normal Form (3NF)\*\*, where each table represents a single entity and all non-key attributes depend only on the primary key.



\---



\## Benefits of the Normalized Design



The normalized schema provides several advantages:



\* Reduction of redundant data

\* Improved data consistency

\* Prevention of insertion, update, and deletion anomalies

\* Better scalability for large transactional systems



By implementing relational integrity through primary and foreign keys, the database structure ensures reliable and efficient data storage.



\---



\## Conclusion



The transformation from a flat dataset to a normalized relational schema significantly improves the reliability and structure of the data. By applying normalization techniques and separating entities into logical tables, the database becomes easier to maintain, query, and scale. This design aligns with standard relational database management practices used in modern data systems.



