import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BookStore(),
    );
  }
}

class BookStore extends StatefulWidget {
  const BookStore({super.key});

  @override
  State<BookStore> createState() => _BookStoreState();
}

class _BookStoreState extends State<BookStore> {
  // Books data
  List<Map<String, dynamic>> books = [
    {"id": 1, "title": "The Great Gatsby", "author": "Fitzgerald", "category": "Fiction", "price": 299},
    {"id": 2, "title": "Flutter Guide", "author": "John Doe", "category": "Technology", "price": 599},
    {"id": 3, "title": "Rich Dad Poor Dad", "author": "Kiyosaki", "category": "Finance", "price": 399},
    {"id": 4, "title": "1984", "author": "Orwell", "category": "Fiction", "price": 279},
    {"id": 5, "title": "Python Programming", "author": "Rossum", "category": "Technology", "price": 499},
    {"id": 6, "title": "Intelligent Investor", "author": "Graham", "category": "Finance", "price": 449},
  ];
  
  // Cart items
  List<Map<String, dynamic>> cart = [];
  
  // Purchase history
  List<Map<String, dynamic>> history = [];
  
  // Search and filter
  String search = "";
  String category = "All";
  List<String> categories = ["All", "Fiction", "Technology", "Finance"];
  
  // Tab index
  int tabIndex = 0;

  // Filter books
  List<Map<String, dynamic>> get filteredBooks {
    return books.where((book) {
      bool matchCategory = category == "All" || book["category"] == category;
      bool matchSearch = search.isEmpty || 
          book["title"].toLowerCase().contains(search.toLowerCase()) ||
          book["author"].toLowerCase().contains(search.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }
  
  // Cart calculations
  double get subtotal {
    double total = 0;
    for (var item in cart) {
      var book = books.firstWhere((b) => b["id"] == item["id"]);
      total += book["price"] * item["qty"];
    }
    return total;
  }
  
  double get gst => subtotal * 0.12;
  double get total => subtotal + gst;
  
  // Add to cart
  void addToCart(Map<String, dynamic> book) {
    setState(() {
      int index = cart.indexWhere((item) => item["id"] == book["id"]);
      if (index != -1) {
        cart[index]["qty"]++;
      } else {
        cart.add({"id": book["id"], "qty": 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${book["title"]} added")),
    );
  }
  
  // Update quantity
  void updateQty(int bookId, int change) {
    setState(() {
      int index = cart.indexWhere((item) => item["id"] == bookId);
      if (index != -1) {
        cart[index]["qty"] += change;
        if (cart[index]["qty"] <= 0) {
          cart.removeAt(index);
        }
      }
    });
  }
  
  // Checkout
  void checkout() {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cart is empty")),
      );
      return;
    }
    
    setState(() {
      history.add({
        "date": DateTime.now().toString(),
        "items": List.from(cart),
        "total": total,
      });
      cart.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Purchase successful!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTabButton("Books", 0),
                buildTabButton("Cart", 1),
                buildTabButton("History", 2),
              ],
            ),
          ),
        ),
      ),
      body: tabIndex == 0 ? buildBooksTab() : (tabIndex == 1 ? buildCartTab() : buildHistoryTab()),
    );
  }
  
  Widget buildTabButton(String title, int index) {
    bool isSelected = tabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => tabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
  
  // Books Tab
  Widget buildBooksTab() {
    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search by title or author...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onChanged: (val) => setState(() => search = val),
          ),
        ),
        // Categories
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text(categories[index]),
                  selected: category == categories[index],
                  onSelected: (_) => setState(() => category = categories[index]),
                  backgroundColor: Colors.grey.shade200,
                  selectedColor: Colors.blue.shade100,
                ),
              );
            },
          ),
        ),
        // Book List
        Expanded(
          child: filteredBooks.isEmpty
              ? const Center(child: Text("No books found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    var book = filteredBooks[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        title: Text(book["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${book["author"]} - ₹${book["price"]}"),
                        trailing: ElevatedButton(
                          onPressed: () => addToCart(book),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: const Text("Add", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  // Cart Tab
  Widget buildCartTab() {
    if (cart.isEmpty) {
      return const Center(child: Text("Cart is empty", style: TextStyle(fontSize: 18)));
    }
    
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cart.length,
            itemBuilder: (context, index) {
              var item = cart[index];
              var book = books.firstWhere((b) => b["id"] == item["id"]);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("₹${book["price"]} each"),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => updateQty(book["id"], -1),
                            icon: const Icon(Icons.remove, color: Colors.red),
                          ),
                          Text("${item["qty"]}", style: const TextStyle(fontSize: 16)),
                          IconButton(
                            onPressed: () => updateQty(book["id"], 1),
                            icon: const Icon(Icons.add, color: Colors.green),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 80,
                        child: Text(
                          "₹${(book["price"] * item["qty"]).toStringAsFixed(2)}",
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Bill Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border(top: BorderSide(color: Colors.blue.shade200)),
          ),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Subtotal:"), Text("₹${subtotal.toStringAsFixed(2)}")]),
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("GST (12%):"), Text("₹${gst.toStringAsFixed(2)}")]),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Total:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("₹${total.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: checkout,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: const Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  // History Tab
  Widget buildHistoryTab() {
    if (history.isEmpty) {
      return const Center(child: Text("No purchase history", style: TextStyle(fontSize: 18)));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: history.length,
      itemBuilder: (context, index) {
        var order = history[history.length - 1 - index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(order["date"].toString().substring(0, 16), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                ...(order["items"] as List).map((item) {
                  var book = books.firstWhere((b) => b["id"] == item["id"]);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• ${book["title"]} x ${item["qty"]} = ₹${book["price"] * item["qty"]}"),
                  );
                }),
                const Divider(),
                Text("Total: ₹${order["total"].toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
