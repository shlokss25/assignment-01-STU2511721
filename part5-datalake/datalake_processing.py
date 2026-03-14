"""
Part 5 — Data Lake Processing Example

This script demonstrates how raw retail data stored in a data lake
can be loaded and analyzed using Python.
"""

import pandas as pd


# --------------------------------------------------
# Load Dataset from Data Lake
# --------------------------------------------------

data = pd.read_csv("datasets/orders_flat.csv")


# --------------------------------------------------
# Display First Records
# --------------------------------------------------

print("Sample Data:")
print(data.head())


# --------------------------------------------------
# Total Revenue
# --------------------------------------------------

total_revenue = data["total_amount"].sum()
print("Total Revenue:", total_revenue)


# --------------------------------------------------
# Orders by Status
# --------------------------------------------------

orders_by_status = data.groupby("status").size()
print("Orders by Status:")
print(orders_by_status)


# --------------------------------------------------
# Top Products by Sales
# --------------------------------------------------

top_products = data.groupby("product_name")["total_amount"].sum().sort_values(ascending=False)
print("Top Products:")
print(top_products)