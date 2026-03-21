\## Normalized Database Schema (3NF)



To resolve these anomalies, the dataset was normalized into four relational tables:



\* \*\*Customers\*\* – Stores customer information (Primary Key: customer\_id)

\* \*\*Products\*\* – Stores product details and pricing (Primary Key: product\_id)

\* \*\*Orders\*\* – Records customer orders (Primary Key: order\_id, Foreign Key: customer\_id)

\* \*\*Order\_Items\*\* – Stores individual items within each order (Foreign Keys: order\_id, product\_id)



This structure follows the principles of \*\*Third Normal Form (3NF)\*\*, which requires that:



1\. The table is in Second Normal Form (2NF)

2\. All non-key attributes are fully functionally dependent on the primary key

3\. There are no transitive dependencies between non-key attributes



By enforcing primary and foreign key relationships, the schema ensures referential integrity and eliminates redundancy.

