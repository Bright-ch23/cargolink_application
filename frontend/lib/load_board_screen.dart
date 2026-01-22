import 'package:flutter/material.dart';

class LoadBoardScreen extends StatefulWidget {
  const LoadBoardScreen({super.key});

  @override
  State<LoadBoardScreen> createState() => _LoadBoardScreenState();
}

class _LoadBoardScreenState extends State<LoadBoardScreen> {
  // Simulated list of available loads
  final List<Map<String, dynamic>> _availableLoads = [
    {
      "id": "LD-5521",
      "origin": "Houston, TX",
      "destination": "Chicago, IL",
      "price": 2400,
      "distance": "1,080 mi",
      "weight": "32,000 lbs",
      "equipment": "Flatbed",
      "date": "Jan 20",
    },
    {
      "id": "LD-8832",
      "origin": "Atlanta, GA",
      "destination": "Miami, FL",
      "price": 1150,
      "distance": "660 mi",
      "weight": "12,000 lbs",
      "equipment": "Reefer",
      "date": "Jan 19",
    },
    {
      "id": "LD-1029",
      "origin": "Los Angeles, CA",
      "destination": "Phoenix, AZ",
      "price": 850,
      "distance": "370 mi",
      "weight": "40,000 lbs",
      "equipment": "Box Truck",
      "date": "Jan 21",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Find Loads"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.blueAccent),
            onPressed: () {
              // Logic for advanced filtering
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Search / Filter Chips
          _buildFilterBar(),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _availableLoads.length,
              itemBuilder: (context, index) {
                return _buildLoadCard(context, _availableLoads[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _filterChip("All Loads", true),
          _filterChip("Flatbed", false),
          _filterChip("Reefer", false),
          _filterChip("Box Truck", false),
          _filterChip("High Paying", false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {},
        backgroundColor: Colors.white.withOpacity(0.05),
        selectedColor: Colors.blueAccent.withOpacity(0.2),
        checkmarkColor: Colors.blueAccent,
        labelStyle: TextStyle(
          color: isSelected ? Colors.blueAccent : Colors.white60,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildLoadCard(BuildContext context, Map<String, dynamic> load) {
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
              Text(load['id'], style: const TextStyle(color: Colors.white24, fontSize: 12)),
              Text("\$${load['price']}",
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 20, fontWeight: FontWeight.bold)),
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
                  Text(load['origin'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 15),
                  Text(load['destination'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _loadInfoDetail(Icons.straighten, load['distance']),
              _loadInfoDetail(Icons.fitness_center, load['weight']),
              _loadInfoDetail(Icons.calendar_today, load['date']),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/load_details');
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
