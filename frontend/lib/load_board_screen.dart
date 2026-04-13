import 'package:flutter/material.dart';
import 'package:cargolink_application/services/api_service.dart';

class LoadBoardScreen extends StatefulWidget {
  final String token;

  const LoadBoardScreen({super.key, required this.token});

  @override
  State<LoadBoardScreen> createState() => _LoadBoardScreenState();
}

class _LoadBoardScreenState extends State<LoadBoardScreen> {
  late Future<List<Map<String, dynamic>>> _availableLoads;

  @override
  void initState() {
    super.initState();
    _availableLoads = ApiService().getAvailableLoads(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Find Loads"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _availableLoads,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          }

          final loads = snapshot.data ?? [];
          if (loads.isEmpty) {
            return const Center(child: Text("No available loads right now.", style: TextStyle(color: Colors.white70)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loads.length,
            itemBuilder: (context, index) {
              return _buildLoadCard(context, loads[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadCard(BuildContext context, Map<String, dynamic> load) {
    final createdAt = (load['created_at'] ?? '').toString();
    final createdDate = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("#${load['id']}", style: const TextStyle(color: Colors.white24, fontSize: 12)),
              Text("\$${load['fare_amount'] ?? 0}", style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Column(
                children: [
                  const Icon(Icons.circle, color: Colors.blueAccent, size: 10),
                  Container(width: 1, height: 20, color: Colors.white10),
                  const Icon(Icons.location_on, color: Colors.redAccent, size: 10),
                ],
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(load['pickup_location'] ?? 'Unknown', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 15),
                  Text(load['dropoff_location'] ?? 'Unknown', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _loadInfoDetail(Icons.category, load['cargo_type'] ?? 'Cargo'),
              _loadInfoDetail(Icons.fitness_center, "${load['cargo_weight_kg'] ?? 0} kg"),
              _loadInfoDetail(Icons.calendar_today, createdDate),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/load_details',
                  arguments: {'token': widget.token, 'load': load},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("View & Bid"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadInfoDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 14),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }
}
