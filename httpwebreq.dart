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
      title: 'Web Service Demo',
      debugShowCheckedModeBanner: false,
      home: const DataFetchingApp(),
    );
  }
}

class DataFetchingApp extends StatefulWidget {
  const DataFetchingApp({super.key});

  @override
  State<DataFetchingApp> createState() => _DataFetchingAppState();
}

class _DataFetchingAppState extends State<DataFetchingApp> {
  List<dynamic> posts = [];
  bool isLoading = false;
  String errorMessage = '';

  // Method to fetch data from API
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Using free JSONPlaceholder API (fake data for testing)
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        setState(() {
          posts = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data. Status: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Web Service Data',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchData,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Fetch button
            ElevatedButton.icon(
              onPressed: fetchData,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Fetch Data from Web Service'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
           
            const SizedBox(height: 20),
           
            // Loading indicator
            if (isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Loading data from web service...'),
                  ],
                ),
              ),
           
            // Error message
            if (errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.red.shade100,
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
           
            // Display fetched data
            if (!isLoading && posts.isNotEmpty)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Showing ${posts.length} posts from web service',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          var post = posts[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${post['id']}. ${post['title']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    post['body'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
           
            // No data message
            if (!isLoading && posts.isEmpty && errorMessage.isEmpty)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, size: 80, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'No data loaded.\nTap the button to fetch data from web service',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
