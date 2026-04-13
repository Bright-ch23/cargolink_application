import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Search Bar
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search for help...",
                hintStyle: const TextStyle(color: Colors.white24),
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Quick Contact Grid
            const Text(
              "Contact Us",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildContactCard(context, Icons.chat_bubble_outline, "Live Chat", "Avg. 2 min"),
                const SizedBox(width: 15),
                _buildContactCard(context, Icons.phone_in_talk_outlined, "Call Center", "24/7 Support"),
              ],
            ),
            const SizedBox(height: 30),

            // FAQ Section
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildFAQTile("How do I track my shipment?"),
            _buildFAQTile("What happens if a driver cancels?"),
            _buildFAQTile("How are insurance claims handled?"),
            _buildFAQTile("When will I receive my invoice?"),

            const SizedBox(height: 30),

            // Support Ticket Status
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.confirmation_number_outlined, color: Colors.blueAccent),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Active Ticket: #TK-4412", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text("Status: Under Review", style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blueAccent, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(question, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.white24),
        onTap: () {},
      ),
    );
  }
}
