


import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Shopping',
      debugShowCheckedModeBanner: false,
      home: const ShoppingApp(),
    );
  }
}

class ShoppingApp extends StatefulWidget {
  const ShoppingApp({super.key});

  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  // Product list
  List<Map<String, dynamic>> products = [
    {"name": "Apple", "price": 50, "qty": 0},
    {"name": "Banana", "price": 30, "qty": 0},
    {"name": "Orange", "price": 40, "qty": 0},
    {"name": "Grapes", "price": 60, "qty": 0},
  ];

  // Calculate total
  int get totalPrice {
    int total = 0;
    for (var product in products) {
      int price = product["price"] as int;
      int qty = product["qty"] as int;
      total = total + (price * qty);
    }
    return total;
  }

  // Add to cart
  void addToCart(int index) {
    setState(() {
      int currentQty = products[index]["qty"] as int;
      products[index]["qty"] = currentQty + 1;
    });
  }

  // Remove from cart
  void removeFromCart(int index) {
    setState(() {
      int currentQty = products[index]["qty"] as int;
      if (currentQty > 0) {
        products[index]["qty"] = currentQty - 1;
      }
    });
  }

  // Buy now
  void buyNow() {
    if (totalPrice == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cart is empty! Add some items")),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Order Placed!"),
          content: Text("Total: ₹$totalPrice\nThank you for shopping!"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  for (var product in products) {
                    product["qty"] = 0;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Products List
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Product info
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index]["name"] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₹${products[index]["price"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          
                          // Quantity controls
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => removeFromCart(index),
                                icon: const Icon(Icons.remove, color: Colors.red),
                              ),
                              Text(
                                "${products[index]["qty"]}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () => addToCart(index),
                                icon: const Icon(Icons.add, color: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const Divider(thickness: 2),
            
            // Bill Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹$totalPrice',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: buyNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
