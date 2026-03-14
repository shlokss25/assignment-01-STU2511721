/*
Part 2 — NoSQL (MongoDB Queries)

This file demonstrates basic MongoDB operations performed on the
orders collection using a document-oriented database model.
The dataset represents retail order transactions.
*/


// --------------------------------------------------
// 1. Insert Order Documents
// --------------------------------------------------

db.orders.insertMany([
  {
    order_id: "ORD2001",
    customer_id: "CUST028",
    order_date: "2023-05-20",
    status: "delivered",
    total_amount: 2397,
    num_items: 1
  }
]);


// --------------------------------------------------
// 2. Retrieve All Orders
// --------------------------------------------------

db.orders.find();


// --------------------------------------------------
// 3. Retrieve Delivered Orders
// --------------------------------------------------

db.orders.find({
  status: "delivered"
});


// --------------------------------------------------
// 4. Find Orders With Total Amount Greater Than 1000
// --------------------------------------------------

db.orders.find({
  total_amount: { $gt: 1000 }
});


// --------------------------------------------------
// 5. Find Orders Placed By A Specific Customer
// --------------------------------------------------

db.orders.find({
  customer_id: "CUST028"
});


// --------------------------------------------------
// 6. Sort Orders By Total Amount (Descending)
// --------------------------------------------------

db.orders.find().sort({
  total_amount: -1
});