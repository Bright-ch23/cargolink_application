import 'package:flutter/material.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated history data
    final List<Map<String, dynamic>> _history = [
      {
        "id": "LD-5521",
        "route": "Houston, TX ➔ Chicago, IL",
        "date": "Jan 12, 2026",
        "price": "\$2,400",
        "status": "Delivered",
        "statusColor": Colors.greenAccent,
      },
      {
        "id": "LD-4410",
        "route": "Atlanta, GA ➔ Miami, FL",
        "date": "Jan 08, 2026",
        "price": "\$1,150",
        "status": "Delivered",
        "statusColor": Colors.greenAccent,
      },
      {
        "id": "LD-3392",
        "route": "Phoenix, AZ ➔ Denver, CO",
        "date": "Jan 02, 2026",
        "price": "\$0",
        "status": "Cancelled",
        "statusColor": Colors.redAccent,
      },
      {
        "id": "LD-2210",
        "route": "Seattle, WA ➔ Portland, OR",
        "date": "Dec 28, 2025",
        "price": "\$650",
        "status": "Delivered",
        "statusColor": Colors.greenAccent,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Trip History"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.blueAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. History Summary
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryStat("32", "Completed"),
                  _SummaryStat("02", "Cancelled"),
                  _SummaryStat("\$48.2k", "Total Value"),
                ],
              ),
            ),
          ),

          // 2. History List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final trip = _history[index];
                return _buildHistoryCard(trip);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trip['id'], style: const TextStyle(color: Colors.white24, fontSize: 12)),
              Text(
                trip['status'],
                style: TextStyle(color: trip['statusColor'], fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(trip['route'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trip['date'], style: const TextStyle(color: Colors.white38, fontSize: 13)),
              Text(
                trip['price'],
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 25),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download_outlined, size: 18),
                label: const Text("Invoice", style: TextStyle(fontSize: 12)),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white24),
            ],
          )
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String value;
  final String label;
  const _SummaryStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
      ],
    );
  }
}