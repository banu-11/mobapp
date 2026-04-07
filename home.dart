

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Automation',
      debugShowCheckedModeBanner: false,
      home: const HomeAutomation(),
    );
  }
}

class HomeAutomation extends StatefulWidget {
  const HomeAutomation({super.key});

  @override
  State<HomeAutomation> createState() => _HomeAutomationState();
}

class _HomeAutomationState extends State<HomeAutomation> {
  bool light = false;
  bool fan = false;
  String gesture = "No gesture";

  void toggleLight() {
    setState(() {
      light = !light;
      gesture = "Tap on Light";
    });
  }

  void toggleFan() {
    setState(() {
      fan = !fan;
      gesture = "Tap on Fan";
    });
  }

  void doubleTap() {
    setState(() {
      light = true;
      fan = true;
      gesture = "Double Tap - All ON";
    });
  }

  void longPress() {
    setState(() {
      light = false;
      fan = false;
      gesture = "Long Press - All OFF";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Automation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: GestureDetector(
        onDoubleTap: doubleTap,
        onLongPress: longPress,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Gesture display
              Container(
                padding: const EdgeInsets.all(15),
                color: Colors.blue.shade50,
                child: Center(
                  child: Text(
                    'Gesture: $gesture',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Light
              GestureDetector(
                onTap: toggleLight,
                child: Card(
                  color: light ? Colors.yellow : Colors.grey,
                  child: ListTile(
                    leading: const Icon(Icons.lightbulb, size: 40),
                    title: const Text('LIGHT', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(light ? 'ON' : 'OFF', style: TextStyle(color: light ? Colors.green : Colors.red)),
                  ),
                ),
              ),
              
              // Fan
              GestureDetector(
                onTap: toggleFan,
                child: Card(
                  color: fan ? Colors.blue : Colors.grey,
                  child: ListTile(
                    leading: const Icon(Icons.toys, size: 40),
                    title: const Text('FAN', style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(fan ? 'ON' : 'OFF', style: TextStyle(color: fan ? Colors.green : Colors.red)),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: const Text(
                  'Gestures:\n• Tap on device → ON/OFF\n• Double Tap anywhere → All ON\n• Long Press anywhere → All OFF',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
