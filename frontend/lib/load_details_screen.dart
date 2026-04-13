import 'package:flutter/material.dart';
import 'package:cargolink_application/services/api_service.dart';

class LoadDetailsScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> load;

  const LoadDetailsScreen({super.key, required this.token, required this.load});

  @override
  Widget build(BuildContext context) {
    final createdAt = (load['created_at'] ?? '').toString();
    final createdDate = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Load Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Offered Fare", style: TextStyle(color: Colors.white38, fontSize: 12)),
                          Text("\$${load['fare_amount'] ?? 0}", style: const TextStyle(color: Colors.greenAccent, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text((load['status'] ?? 'Pending').toString(), style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10, height: 40),
                  _buildDetailRow(Icons.radio_button_checked, "Pickup", load['pickup_location'] ?? 'Unknown', "Created $createdDate"),
                  const SizedBox(height: 20),
                  _buildDetailRow(Icons.location_on, "Drop-off", load['dropoff_location'] ?? 'Unknown', "Booking #${load['id']}"),
                  const SizedBox(height: 30),
                  const Text("Cargo Specifications", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        _buildSpecItem("Cargo Type", load['cargo_type'] ?? 'Cargo'),
                        _buildSpecItem("Weight", "${load['cargo_weight_kg'] ?? 0} kg"),
                        _buildSpecItem("Current Status", load['status'] ?? 'Pending'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFF1A1F26),
        child: SizedBox(
          width: double.infinity,
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
    final bidController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F26),
        title: const Text("Place your Bid", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bidController,
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
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Optional note",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final result = await ApiService().placeBid(
                token: token,
                bookingId: load['id'].toString(),
                amount: double.tryParse(bidController.text.trim()) ?? 0,
                message: noteController.text.trim(),
              );

              if (!dialogContext.mounted) return;
              Navigator.pop(dialogContext);

              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result['error'] == true ? "Failed to submit bid: ${result['message']}" : "Bid submitted successfully.",
                  ),
                ),
              );
            },
            child: const Text("Submit Bid"),
          ),
        ],
      ),
    );
  }
}
