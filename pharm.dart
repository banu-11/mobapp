import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacy Store',
      debugShowCheckedModeBanner: false,
      home: const MedicineList(),
    );
  }
}

// Medicine Model
class Medicine {
  String name;
  String dosage;
  bool prescription;
  String expiry;
  double price;
  int quantity;

  Medicine({required this.name, required this.dosage, required this.prescription, required this.expiry, required this.price, this.quantity = 1});
}

class MedicineList extends StatefulWidget {
  const MedicineList({super.key});

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  List<Medicine> medicines = [
    Medicine(name: 'Paracetamol', dosage: '500mg', prescription: false, expiry: '2025-12-31', price: 25),
    Medicine(name: 'Amoxicillin', dosage: '250mg', prescription: true, expiry: '2024-10-15', price: 120),
    Medicine(name: 'Cetrizine', dosage: '10mg', prescription: false, expiry: '2025-06-20', price: 45),
    Medicine(name: 'Insulin', dosage: '100IU', prescription: true, expiry: '2024-08-01', price: 350),
  ];

  List<Medicine> cart = [];

  void addToCart(Medicine m) {
    setState(() {
      bool exists = false;
      for (var item in cart) {
        if (item.name == m.name) {
          item.quantity++;
          exists = true;
          break;
        }
      }
      if (!exists) {
        cart.add(Medicine(name: m.name, dosage: m.dosage, prescription: m.prescription, expiry: m.expiry, price: m.price));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${m.name} added')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy Store'),
        backgroundColor: Colors.green,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(cart: cart))),
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Text('${cart.length}', style: const TextStyle(fontSize: 12))),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          Medicine m = medicines[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.medication, size: 40),
              title: Text(m.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dosage: ${m.dosage}'),
                  Text(m.prescription ? '⚠️ Prescription Required' : '✅ OTC Medicine', style: TextStyle(color: m.prescription ? Colors.red : Colors.green)),
                  Text('Expires: ${m.expiry}', style: TextStyle(color: m.expiry.contains('2024') ? Colors.red : Colors.black)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('₹${m.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(onPressed: () => addToCart(m), child: const Text('Add')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Cart Page
class CartPage extends StatefulWidget {
  final List<Medicine> cart;
  const CartPage({super.key, required this.cart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void changeQty(int index, int delta) {
    setState(() {
      if (widget.cart[index].quantity + delta > 0) {
        widget.cart[index].quantity += delta;
      } else {
        widget.cart.removeAt(index);
      }
    });
  }

  double getSubtotal() {
    double total = 0;
    for (var item in widget.cart) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = getSubtotal();
    double tax = subtotal * 0.05;
    double total = subtotal + tax;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), backgroundColor: Colors.green),
      body: widget.cart.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      Medicine m = widget.cart[index];
                      return Card(
                        child: ListTile(
                          title: Text(m.name),
                          subtitle: Text('₹${m.price} each'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: () => changeQty(index, -1), icon: const Icon(Icons.remove, color: Colors.red)),
                              Text('${m.quantity}', style: const TextStyle(fontSize: 18)),
                              IconButton(onPressed: () => changeQty(index, 1), icon: const Icon(Icons.add, color: Colors.green)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal:'), Text('₹${subtotal.toStringAsFixed(2)}')]),
                      const SizedBox(height: 5),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tax (5%):'), Text('₹${tax.toStringAsFixed(2)}')]),
                      const Divider(),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)), Text('₹${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutPage(cart: widget.cart, subtotal: subtotal, tax: tax, total: total))),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Confirm & Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// Checkout Page - FIXED VERSION
class CheckoutPage extends StatelessWidget {
  final List<Medicine> cart;
  final double subtotal;
  final double tax;
  final double total;

  const CheckoutPage({super.key, required this.cart, required this.subtotal, required this.tax, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice'), backgroundColor: Colors.green),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('MEDICINE INVOICE', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...cart.map((m) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${m.name} x ${m.quantity}'), Text('₹${(m.price * m.quantity).toStringAsFixed(2)}')]),
                        )),
                        const Divider(),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal:'), Text('₹${subtotal.toStringAsFixed(2)}')]),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Tax (5%):'), Text('₹${tax.toStringAsFixed(2)}')]),
                        const Divider(),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('TOTAL:', style: TextStyle(fontWeight: FontWeight.bold)), Text('₹${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('⚠️ HEALTH DISCLAIMERS:', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('• Take medicines as prescribed by doctor'),
                      Text('• Check expiry date before use'),
                      Text('• Do not self-medicate'),
                      Text('• Keep away from children'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Order Placed!'),
                      content: const Text('Your order has been confirmed successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 15)),
                child: const Text('Confirm & Place Order', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
