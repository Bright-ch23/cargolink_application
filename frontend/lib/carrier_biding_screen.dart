import 'package:flutter/material.dart';

class CarrierBiddingScreen extends StatelessWidget {
  const CarrierBiddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Incoming Bids", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Load: Electronics Batch A", style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildBidCard(
            context,
            driverName: "Alex Johnson",
            vehicle: "Semi-Truck (Box)",
            rating: "4.8",
            price: "850",
            time: "20 mins ago",
            isRecommended: true,
          ),
          _buildBidCard(
            context,
            driverName: "Sarah Miller",
            vehicle: "Flatbed Truck",
            rating: "4.5",
            price: "790",
            time: "45 mins ago",
            isRecommended: false,
          ),
          _buildBidCard(
            context,
            driverName: "Mike’s Logistics",
            vehicle: "Heavy Hauler",
            rating: "4.9",
            price: "920",
            time: "1 hour ago",
            isRecommended: false,
          ),
        ],
      ),
    );
  }

  Widget _buildBidCard(
      BuildContext context, {
        required String driverName,
        required String vehicle,
        required String rating,
        required String price,
        required String time,
        required bool isRecommended,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F26),
        borderRadius: BorderRadius.circular(20),
        border: isRecommended
            ? Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2)
            : Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          if (isRecommended)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: const Text(
                "BEST VALUE",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white10,
                      child: Text(driverName[0], style: const TextStyle(color: Colors.blueAccent)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(driverName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(vehicle, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("\$$price", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 20)),
                        Text(time, style: const TextStyle(color: Colors.white30, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orangeAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(rating, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                        const Text(" (120+ trips)", style: TextStyle(color: Colors.white30, fontSize: 12)),
                      ],
                    ),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Decline", style: TextStyle(color: Colors.white70)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Link to tracking map or payment
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Accept Bid"),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}