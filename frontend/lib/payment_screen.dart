import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Payment Details"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipment Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Load ID", "#CL-88291", isBold: true),
                  const Divider(color: Colors.white10, height: 30),
                  _buildSummaryRow("Base Freight", "\XAF 1500"),
                  _buildSummaryRow("Insurance", "\XAF 700"),
                  _buildSummaryRow("Service Fee", "\XAF 1000"),
                  const Divider(color: Colors.white10, height: 30),
                  _buildSummaryRow("Total Amount", "\XAF 3200", isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 40),
            const Text(
              "Select Payment Method",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Payment Options
            _buildPaymentMethod('assets/logos/master-card_logo.png', "Mastercard", "**** **** **** 4242", true),
            _buildPaymentMethod('assets/logos/momo_logo.png', "MTN Mobile Money", "+237 67 **** 589", false),
            _buildPaymentMethod('assets/logos/orange 1.png', "Orange Money", "+237 69 **** 231", false),

            const SizedBox(height: 40),

            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  _showSuccessDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "Confirm & Pay \XAF 3200",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Secure 256-bit SSL Encrypted Payment",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.white : Colors.white60, fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(color: isTotal ? Colors.greenAccent : Colors.white, fontSize: isTotal ? 20 : 14, fontWeight: isBold || isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(String imagePath, String title, String subtitle, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent.withOpacity(0.1) : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected ? Colors.blueAccent : Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, height: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
          ),
          if (isSelected) const Icon(Icons.check_circle, color: Colors.blueAccent),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 80),
            const SizedBox(height: 20),
            const Text("Payment Successful!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Your load is now scheduled for pickup.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white60)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/shipper_dashboard', (route) => false),
                child: const Text("Go to Dashboard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
