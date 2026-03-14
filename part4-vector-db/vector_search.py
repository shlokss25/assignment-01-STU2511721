"""
Part 4 — Vector Database Demonstration

This script demonstrates how vector embeddings can be used
to perform similarity search on retail product data.
"""

import numpy as np


# --------------------------------------------------
# Example Product Embeddings
# --------------------------------------------------

products = [
    "Laptop",
    "Smartphone",
    "Headphones",
    "Smartwatch"
]

# Simulated vector embeddings
embeddings = np.array([
    [0.9, 0.1, 0.2],
    [0.85, 0.15, 0.3],
    [0.2, 0.9, 0.7],
    [0.3, 0.8, 0.6]
])


# --------------------------------------------------
# Query Vector
# --------------------------------------------------

query_vector = np.array([0.88, 0.12, 0.25])


# --------------------------------------------------
# Cosine Similarity Function
# --------------------------------------------------

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))


# --------------------------------------------------
# Find Most Similar Product
# --------------------------------------------------

similarities = []

for vector in embeddings:
    similarities.append(cosine_similarity(query_vector, vector))

best_match_index = np.argmax(similarities)

print("Most similar product:", products[best_match_index])