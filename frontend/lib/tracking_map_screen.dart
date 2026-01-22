import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackingMapScreen extends StatefulWidget {
  final String bookingId; // Pass the ID of the booking to track
  final String token;

  const TrackingMapScreen({super.key, required this.bookingId, required this.token});

  @override
  State<TrackingMapScreen> createState() => _TrackingMapScreenState();
}

class _TrackingMapScreenState extends State<TrackingMapScreen> {
  final String baseUrl = "http://10.0.2.2:8000/api";
  Map<String, dynamic>? trackingData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTrackingData();
  }

  Future<void> fetchTrackingData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bookings/${widget.bookingId}/track/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          trackingData = jsonDecode(response.body);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Tracking Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          // MAP PLACEHOLDER
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF1E293B),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.blueAccent, size: 50),
                  Text(
                    "Lat: ${trackingData?['lat']} \n Lng: ${trackingData?['lng']}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            ),
          ),

          // Draggable Status Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.2,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1F26),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Center(
                      child: Container(width: 40, height: 5, color: Colors.white24),
                    ),
                    const SizedBox(height: 25),

                    // Driver Info from Backend
                    Row(
                      children: [
                        const CircleAvatar(radius: 25, backgroundColor: Colors.blueGrey, child: Icon(Icons.person)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trackingData?['driver_name'] ?? "Unknown Driver",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              Text(trackingData?['vehicle'] ?? "In Transit",
                                  style: const TextStyle(color: Colors.white54, fontSize: 14)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.blueAccent),
                          onPressed: fetchTrackingData,
                        )
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 40),
                    _buildTrackingStep("Current Status", trackingData?['status'] ?? "Checking...", true, true),
                    _buildTrackingStep("Last Updated", trackingData?['last_updated']?.toString().substring(11, 16) ?? "N/A", false, false),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String title, String subtitle, bool isCompleted, bool showLine) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? Colors.blueAccent : Colors.white24, size: 20),
            if (showLine) Container(width: 2, height: 40, color: Colors.blueAccent.withOpacity(0.3)),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(subtitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
          ],
        ),
      ],
    );
  }
}