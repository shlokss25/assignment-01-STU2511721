"""
Part 4 — Big Data Processing using PySpark
This script demonstrates how retail order data can be processed using PySpark.
"""

# --------------------------------------------------
# Import Library
# --------------------------------------------------

from pyspark.sql import SparkSession


# --------------------------------------------------
# Create Spark Session
# --------------------------------------------------

spark = SparkSession.builder \
    .appName("RetailOrderAnalysis") \
    .getOrCreate()


# --------------------------------------------------
# Load Dataset
# --------------------------------------------------

orders_df = spark.read.csv(
    "datasets/orders_flat.csv",
    header=True,
    inferSchema=True
)


# --------------------------------------------------
# Display Dataset
# --------------------------------------------------

orders_df.show()


# --------------------------------------------------
# Total Sales by Product
# --------------------------------------------------

sales_by_product = orders_df.groupBy("product_name").sum("total_amount")

sales_by_product.show()


# --------------------------------------------------
# Orders by Status
# --------------------------------------------------

orders_by_status = orders_df.groupBy("status").count()

orders_by_status.show()


# --------------------------------------------------
# Stop Spark Session
# --------------------------------------------------

spark.stop()