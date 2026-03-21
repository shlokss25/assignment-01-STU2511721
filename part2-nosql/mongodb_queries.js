/*
Part 2 — MongoDB Queries
Basic operations performed on orders collection
*/

// inserting sample orders
db.orders.insertMany([
  {
    order_id: "ORD2001",
    customer_id: "CUST028",
    order_date: new Date("2023-05-20"),
    status: "delivered",
    total_amount: 2397,
    num_items: 1
  },
  {
    order_id: "ORD2002",
    customer_id: "CUST015",
    order_date: new Date("2023-05-21"),
    status: "pending",
    total_amount: 1200,
    num_items: 2
  },
  {
    order_id: "ORD2003",
    customer_id: "CUST028",
    order_date: new Date("2023-05-22"),
    status: "cancelled",
    total_amount: 800,
    num_items: 1
  }
]);


// get all orders
db.orders.find();

// only delivered orders
db.orders.find({ status: "delivered" });

// orders with amount > 1000
db.orders.find({ total_amount: { $gt: 1000 } });

// orders for a specific customer
db.orders.find({ customer_id: "CUST028" });

// sort by total amount (high to low)
db.orders.find().sort({ total_amount: -1 });

// projection example (only show few fields)
db.orders.find({}, { order_id: 1, total_amount: 1, _id: 0 });

// update status of one order
db.orders.updateOne(
  { order_id: "ORD2002" },
  { $set: { status: "delivered" } }
);

// delete an order
db.orders.deleteOne({ order_id: "ORD2003" });


// total revenue
db.orders.aggregate([
  {
    $group: {
      _id: null,
      total_revenue: { $sum: "$total_amount" }
    }
  }
]);

// revenue grouped by status
db.orders.aggregate([
  {
    $group: {
      _id: "$status",
      total_revenue: { $sum: "$total_amount" }
    }
  }
]);