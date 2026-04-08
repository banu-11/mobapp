import 'package:flutter/material.dart';

void main() {
  runApp(const SafetyApp());
}

class SafetyApp extends StatelessWidget {
  const SafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Chennai (Simulated Location)";
  int tapCount = 0;

  void sendSOS(String reason) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🚨 SOS ALERT"),
        content: Text("$reason\nLocation: $location"),
      ),
    );
  }

  void handleTap() {
    tapCount++;
    if (tapCount == 3) {
      sendSOS("Triple Tap Detected!");
      tapCount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Women Safety App"),
          backgroundColor: Colors.pink,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Current Location:\n$location",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onLongPress: () {
                  sendSOS("Silent Emergency Mode Activated!");
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.red,
                  child: const Center(
                    child: Text(
                      "LONG PRESS FOR SOS",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    location = "Updated Location (Simulated)";
                  });
                },
                child: const Text("Update Location"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      title: Text("Nearby Police Station"),
                      content: Text("XYZ Police Station (Simulated)"),
                    ),
                  );
                },
                child: const Text("Find Nearby Police Station"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      title: Text("Nearby Hospital"),
                      content: Text("ABC Hospital (Simulated)"),
                    ),
                  );
                },
                child: const Text("Find Nearby Hospital"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
