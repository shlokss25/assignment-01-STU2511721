\# Part 4 — Vector Database



\## Introduction



Modern artificial intelligence applications often rely on \*\*vector embeddings\*\* to represent complex data such as text, images, and audio. These embeddings convert data into numerical vectors that capture semantic meaning. Vector databases are designed to store and search these vectors efficiently using similarity search techniques.



In this part of the assignment, a simple simulation of vector similarity search was implemented to demonstrate the core concept behind vector databases.



\---



\## Vector Embeddings



A vector embedding is a numerical representation of data in multi-dimensional space. Each object is represented as a vector containing several numerical values.



For example:



\* Product descriptions

\* Customer reviews

\* Images

\* Text documents



can all be converted into vector representations.



These vectors allow machines to compare the similarity between different items.



\---



\## Similarity Search



Vector databases perform \*\*similarity search\*\* to identify items that are closest to a given query vector.



In this implementation:



1\. Product data was represented using simulated vector embeddings.

2\. A query vector was defined to represent a search request.

3\. Cosine similarity was used to calculate how similar each product vector is to the query vector.

4\. The product with the highest similarity score was identified as the most relevant result.



\---



\## Cosine Similarity



Cosine similarity is one of the most common techniques used in vector search. It measures the cosine of the angle between two vectors.



Values closer to \*\*1\*\* indicate higher similarity, while values closer to \*\*0\*\* indicate lower similarity.



This method is widely used in recommendation systems, semantic search engines, and modern AI applications.



\---



\## Conclusion



This section demonstrates the fundamental concept behind vector databases by implementing a basic vector similarity search algorithm. By representing data as embeddings and comparing vectors using cosine similarity, it becomes possible to efficiently retrieve the most relevant items from large datasets.



