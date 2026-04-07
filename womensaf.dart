import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Woman Safety App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const SafetyApp(),
    );
  }
}

class SafetyApp extends StatefulWidget {
  const SafetyApp({super.key});

  @override
  State<SafetyApp> createState() => _SafetyAppState();
}

class _SafetyAppState extends State<SafetyApp> {
  bool isSilentMode = false;
  String currentLocation = "Tap 'Get Location' to fetch";
  double latitude = 0.0;
  double longitude = 0.0;
  List<String> messages = [];
  
  // For triple tap detection
  int tapCount = 0;
  Timer? tapTimer;

  // Get real-time GPS location
  Future<void> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          currentLocation = "Please enable GPS";
        });
        showNotification("Please enable location services");
        return;
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            currentLocation = "Location permission denied";
          });
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        currentLocation = "📍 Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}";
      });
      
      showNotification("Location updated successfully!");
    } catch (e) {
      setState(() {
        currentLocation = "Error: ${e.toString()}";
      });
      showNotification("Failed to get location");
    }
  }

  // Send SOS Alert
  void sendSOSAlert(String triggerType) {
    String time = "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
    
    setState(() {
      messages.insert(0, "$time - 🚨 SOS! Trigger: $triggerType");
      messages.insert(0, "📍 $currentLocation");
    });

    // Show alert dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🚨 SOS ALERT!", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Trigger: $triggerType", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Location: $currentLocation"),
            const SizedBox(height: 8),
            const Text("Emergency services have been notified!", style: TextStyle(color: Colors.red)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              callPolice();
              Navigator.pop(context);
            },
            child: const Text("Call Police", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    showNotification("🚨 SOS ALERT! $triggerType");
  }

  // Silent emergency mode
  void toggleSilentMode() {
    setState(() {
      isSilentMode = !isSilentMode;
      if (isSilentMode) {
        sendSilentAlert();
      }
    });
  }

  void sendSilentAlert() {
    String time = "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
    setState(() {
      messages.insert(0, "$time - 🔇 SILENT MODE ACTIVATED");
      messages.insert(0, "📍 Location shared silently: $currentLocation");
    });
    showNotification("🔇 Silent mode active! Location shared");
  }

  // Share location
  void shareLocation() async {
    if (latitude == 0.0) {
      showNotification("Please get location first");
      return;
    }
    
    String locationText = "EMERGENCY! Need help.\nMy location:\nLat: $latitude, Lng: $longitude\nGoogle Maps: https://maps.google.com/?q=$latitude,$longitude";
    
    setState(() {
      messages.insert(0, "📍 Location shared: $currentLocation");
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Share Location"),
        content: Text(locationText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // Show notification (Snackbar)
  void showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSilentMode ? Colors.orange : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Call police
  void callPolice() async {
    Uri telUri = Uri(scheme: 'tel', path: '100');
    try {
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        showNotification("Cannot make calls on web browser");
      }
    } catch (e) {
      showNotification("Call feature not available on web");
    }
  }

  // Find nearby police station
  void findNearbyPolice() async {
    if (latitude == 0.0) {
      showNotification("Please get location first");
      return;
    }
    
    String url = "https://www.google.com/maps/search/police+station/@$latitude,$longitude,15z";
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        setState(() {
          messages.insert(0, "👮 Searching nearby police stations...");
        });
        showNotification("Opening Google Maps");
      }
    } catch (e) {
      showNotification("Cannot open maps");
    }
  }

  // Find nearby hospital
  void findNearbyHospital() async {
    if (latitude == 0.0) {
      showNotification("Please get location first");
      return;
    }
    
    String url = "https://www.google.com/maps/search/hospital/@$latitude,$longitude,15z";
    Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        setState(() {
          messages.insert(0, "🏥 Searching nearby hospitals...");
        });
        showNotification("Opening Google Maps");
      }
    } catch (e) {
      showNotification("Cannot open maps");
    }
  }

  // Triple tap detection
  void onTripleTap() {
    tapCount++;
    if (tapTimer != null) {
      tapTimer!.cancel();
    }
    tapTimer = Timer(const Duration(milliseconds: 500), () {
      if (tapCount >= 3) {
        sendSOSAlert("Triple Tap");
      }
      tapCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Woman Safety App"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(isSilentMode ? Icons.volume_off : Icons.volume_up),
            onPressed: toggleSilentMode,
            tooltip: "Silent Emergency Mode",
          ),
        ],
      ),
      body: GestureDetector(
        onTap: onTripleTap,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Location Card
              Card(
                margin: const EdgeInsets.all(16),
                elevation: 4,
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.red, size: 30),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("CURRENT LOCATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 4),
                                Text(currentLocation, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: getCurrentLocation,
                        icon: const Icon(Icons.gps_fixed),
                        label: const Text("Get Real-time GPS Location"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // SOS Button (Long Press)
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onLongPress: () {
                    if (isSilentMode) {
                      sendSilentAlert();
                    } else {
                      sendSOSAlert("Long Press");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.red, Colors.redAccent]),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.red.shade300, blurRadius: 10, spreadRadius: 2),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning, size: 50, color: Colors.white),
                        SizedBox(height: 10),
                        Text("LONG PRESS FOR SOS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Emergency Alert", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),

              // Action Buttons Row 1
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: shareLocation,
                        icon: const Icon(Icons.share_location),
                        label: const Text("Share Location"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: callPolice,
                        icon: const Icon(Icons.phone),
                        label: const Text("Call Police"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Action Buttons Row 2
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: findNearbyPolice,
                        icon: const Icon(Icons.local_police),
                        label: const Text("Police Station"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: findNearbyHospital,
                        icon: const Icon(Icons.local_hospital),
                        label: const Text("Hospital"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Instructions
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.yellow.shade700),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📱 HOW TO USE:", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("• Triple tap anywhere → SOS Alert"),
                    Text("• Long press RED button → Emergency SOS"),
                    Text("• Silent mode (top-right icon) → Silent alert"),
                    Text("• Get Location first, then use other features"),
                    Text("• Police/Hospital → Opens Google Maps"),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Alert History
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("📋 ALERT HISTORY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    Expanded(
                      child: messages.isEmpty
                          ? const Center(child: Text("No alerts yet"))
                          : ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(Icons.notifications_active, color: Colors.red, size: 20),
                                  title: Text(messages[index], style: const TextStyle(fontSize: 12)),
                                  dense: true,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


