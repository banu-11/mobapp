import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      debugShowCheckedModeBanner: false,
      home: const NotificationDemo(),
    );
  }
}

class NotificationDemo extends StatefulWidget {
  const NotificationDemo({super.key});

  @override
  State<NotificationDemo> createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  // Method to show push notification using SnackBar
  void showPushNotification(String message, {Color backgroundColor = Colors.blue}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            print('Notification dismissed');
          },
        ),
      ),
    );
  }

  // Example 1: Simple notification
  void sendSimpleNotification() {
    showPushNotification('This is a simple push notification!');
  }

  // Example 2: Success notification
  void sendSuccessNotification() {
    showPushNotification(
      '✅ Operation completed successfully!',
      backgroundColor: Colors.green,
    );
  }

  // Example 3: Error notification
  void sendErrorNotification() {
    showPushNotification(
      '❌ Something went wrong! Please try again.',
      backgroundColor: Colors.red,
    );
  }

  // Example 4: Warning notification
  void sendWarningNotification() {
    showPushNotification(
      '⚠️ Warning: Low battery!',
      backgroundColor: Colors.orange,
    );
  }

  // Example 5: Custom notification with user input
  void sendCustomNotification() {
    String customMessage = 'You have a new message from user';
    showPushNotification(
      customMessage,
      backgroundColor: Colors.purple,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Push Notification Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(  // ← FIX: Added this to make content scrollable
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Click buttons to test notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Example buttons
              ElevatedButton.icon(
                onPressed: sendSimpleNotification,
                icon: const Icon(Icons.notifications),
                label: const Text('Simple Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              
              const SizedBox(height: 15),
              
              ElevatedButton.icon(
                onPressed: sendSuccessNotification,
                icon: const Icon(Icons.check_circle),
                label: const Text('Success Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              
              const SizedBox(height: 15),
              
              ElevatedButton.icon(
                onPressed: sendErrorNotification,
                icon: const Icon(Icons.error),
                label: const Text('Error Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              
              const SizedBox(height: 15),
              
              ElevatedButton.icon(
                onPressed: sendWarningNotification,
                icon: const Icon(Icons.warning),
                label: const Text('Warning Notification'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              
              const SizedBox(height: 15),
              
              ElevatedButton.icon(
                onPressed: sendCustomNotification,
                icon: const Icon(Icons.message),
                label: const Text('Custom Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Custom message input example
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Send Custom Message:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your message here',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            showPushNotification(
                              'Custom message sent!',
                              backgroundColor: Colors.teal,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '💡 Tip: Modify the showPushNotification() function to change:\n'
                  '• Message text\n'
                  '• Background color\n'
                  '• Duration\n'
                  '• Icon\n'
                  '• Action buttons',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              
              const SizedBox(height: 20), // Extra space at bottom
            ],
          ),
        ),
      ),
    );
  }
}
