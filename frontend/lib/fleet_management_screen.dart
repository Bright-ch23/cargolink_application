import 'package:flutter/material.dart';

class FleetManagementScreen extends StatelessWidget {
  const FleetManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated fleet data
    final List<Map<String, dynamic>> _fleet = [
      {
        "id": "TRK-101",
        "model": "Ken worth T680",
        "plate": "TX-9920",
        "status": "On Trip",
        "driver": "Alex J.",
        "color": Colors.blueAccent
      },
      {
        "id": "TRK-105",
        "model": "Road liner 579",
        "plate": "CA-4412",
        "status": "Available",
        "driver": "Unassigned",
        "color": Colors.greenAccent
      },
      {
        "id": "TRK-202",
        "model": "Freight liner Cascadia",
        "plate": "NY-8831",
        "status": "Maintenance",
        "driver": "None",
        "color": Colors.orangeAccent
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Fleet Management"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Fleet Summary Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem("Total", "03"),
                _buildSummaryItem("Active", "01"),
                _buildSummaryItem("Available", "01"),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _fleet.length,
              itemBuilder: (context, index) {
                final truck = _fleet[index];
                return _buildTruckCard(truck);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add a new truck
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String count) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _buildTruckCard(Map<String, dynamic> truck) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (truck['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_shipping, color: truck['color'] as Color),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(truck['model'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("Plate: ${truck['plate']}", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (truck['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: (truck['color'] as Color).withOpacity(0.5)),
                ),
                child: Text(
                  truck['status'],
                  style: TextStyle(color: truck['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.white24, size: 16),
                  const SizedBox(width: 5),
                  Text(truck['driver'], style: const TextStyle(color: Colors.white60, fontSize: 13)),
                ],
              ),
              const Text("View Details", style: TextStyle(color: Colors.blueAccent, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}