import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const QuotesApp(),
    );
  }
}

class QuotesApp extends StatefulWidget {
  const QuotesApp({super.key});

  @override
  State<QuotesApp> createState() => _QuotesAppState();
}

class _QuotesAppState extends State<QuotesApp> {
  String quote = "Loading...";
  String author = "";
  bool isLoading = true;
  bool isError = false;

  // Free API for quotes (no key needed)
  List<String> quoteAPIs = [
    "https://api.quotable.io/random",
    "https://type.fit/api/quotes",
  ];

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      // Using free API - quotable.io (no API key needed)
      final response = await http.get(
        Uri.parse("https://api.quotable.io/random"),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          quote = data['content'];
          author = data['author'];
          isLoading = false;
        });
      } else {
        // Fallback to local quotes if API fails
        getLocalQuote();
      }
    } catch (e) {
      // Use local quotes if API fails
      getLocalQuote();
    }
  }

  void getLocalQuote() {
    List<Map<String, String>> localQuotes = [
      {"quote": "The only limit is your mind.", "author": "Unknown"},
      {"quote": "Stay positive, work hard, make it happen.", "author": "Anonymous"},
      {"quote": "Believe you can and you're halfway there.", "author": "Theodore Roosevelt"},
      {"quote": "Don't watch the clock; do what it does. Keep going.", "author": "Sam Levenson"},
      {"quote": "The future depends on what you do today.", "author": "Mahatma Gandhi"},
      {"quote": "It always seems impossible until it's done.", "author": "Nelson Mandela"},
      {"quote": "Success is not final, failure is not fatal.", "author": "Winston Churchill"},
      {"quote": "You are stronger than you think.", "author": "Unknown"},
    ];
    
    int randomIndex = DateTime.now().millisecondsSinceEpoch % localQuotes.length;
    setState(() {
      quote = localQuotes[randomIndex]["quote"]!;
      author = localQuotes[randomIndex]["author"]!;
      isLoading = false;
    });
  }

  void nextQuote() {
    fetchQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📖 Quotes App"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swipe left or right to get new quote
          if (details.primaryVelocity! > 0) {
            nextQuote(); // Swipe right
          } else if (details.primaryVelocity! < 0) {
            nextQuote(); // Swipe left
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple.shade50, Colors.blue.shade50],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.purple),
                        const SizedBox(height: 20),
                        Text(
                          "Loading quote...",
                          style: TextStyle(color: Colors.purple.shade700),
                        ),
                      ],
                    )
                  : Card(
                      elevation: 10,
                      shadowColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.purple.shade50],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Quote icon
                            Icon(
                              Icons.format_quote,
                              size: 50,
                              color: Colors.purple.shade300,
                            ),
                            const SizedBox(height: 20),
                            // Quote text
                            Text(
                              "\"$quote\"",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            // Author
                            Text(
                              "- $author",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.purple.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            // Swipe instruction
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.swipe,
                                    size: 18,
                                    color: Colors.purple.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Swipe Left/Right for Next Quote",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.purple.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
      // Floating button to get new quote
      floatingActionButton: FloatingActionButton(
        onPressed: nextQuote,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
