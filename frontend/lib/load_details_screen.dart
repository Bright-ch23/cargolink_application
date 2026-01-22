import 'package:flutter/material.dart';

class LoadDetailsScreen extends StatelessWidget {
  const LoadDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Load Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Map Placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.white.withOpacity(0.05),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.map_outlined, color: Colors.blueAccent.withOpacity(0.5), size: 50),
                  const Positioned(
                    bottom: 10,
                    right: 10,
                    child: Text("Live Map Preview", style: TextStyle(color: Colors.white24, fontSize: 10)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Pricing and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Fixed Price", style: TextStyle(color: Colors.white38, fontSize: 12)),
                          Text("\$2,400.00", style: TextStyle(color: Colors.greenAccent, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: const Text("Verified Shipper", style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 40),

                  // 3. Route Details
                  _buildDetailRow(Icons.radio_button_checked, "Pickup", "Houston, TX", "Jan 20, 2026 • 08:00 AM"),
                  const SizedBox(height: 20),
                  _buildDetailRow(Icons.location_on, "Drop-off", "Chicago, IL", "Jan 22, 2026 • 04:00 PM"),

                  const SizedBox(height: 30),

                  // 4. Cargo Specs
                  const Text("Cargo Specifications", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildSpecItem("Equipment", "48' Flatbed"),
                        _buildSpecItem("Weight", "32,000 lbs"),
                        _buildSpecItem("Commodity", "Industrial Steel Pipes"),
                        _buildSpecItem("Special Info", "Requires Heavy Duty Tarps"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ],
        ),
      ),
      // 5. Bottom Action Bar
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFF1A1F26),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showBidDialog(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blueAccent),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Place Bid", style: TextStyle(color: Colors.blueAccent)),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Accept Load", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String title, String sub) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: label == "Pickup" ? Colors.blueAccent : Colors.redAccent, size: 20),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white38)),
          Text(value, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  void _showBidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F26),
        title: const Text("Place your Bid", style: TextStyle(color: Colors.white)),
        content: TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixText: "\$ ",
            prefixStyle: const TextStyle(color: Colors.white),
            hintText: "Enter amount",
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Submit Bid")),
        ],
      ),
    );
  }
}