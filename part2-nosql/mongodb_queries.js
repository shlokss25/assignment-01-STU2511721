/*
Part 2 — MongoDB (based on orders.json)
*/

// insert sample documents
db.orders.insertMany([
  {
    order_id: "ORD1001",
    customer_id: "CUST001",
    order_date: new Date("2023-05-10"),
    status: "delivered",
    total_amount: 2500,
    items: [
      { product: "Shoes", quantity: 1, price: 2500 }
    ]
  },
  {
    order_id: "ORD1002",
    customer_id: "CUST002",
    order_date: new Date("2023-05-11"),
    status: "pending",
    total_amount: 4500,
    items: [
      { product: "Phone", quantity: 1, price: 4500 }
    ]
  }
]);

// get all orders
db.orders.find();

// delivered orders
db.orders.find({ status: "delivered" });

// high value orders
db.orders.find({ total_amount: { $gt: 3000 } });

// orders for a customer
db.orders.find({ customer_id: "CUST001" });

// sort by amount
db.orders.find().sort({ total_amount: -1 });

// update status
db.orders.updateOne(
  { order_id: "ORD1002" },
  { $set: { status: "delivered" } }
);

// delete example
db.orders.deleteOne({ order_id: "ORD1002" });

// total revenue
db.orders.aggregate([
  {
    $group: {
      _id: null,
      total: { $sum: "$total_amount" }
    }
  }
]);