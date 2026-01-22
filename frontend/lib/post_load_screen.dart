import 'package:flutter/material.dart';

class PostLoadScreen extends StatefulWidget {
  const PostLoadScreen({super.key});

  @override
  State<PostLoadScreen> createState() => _PostLoadScreenState();
}

class _PostLoadScreenState extends State<PostLoadScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Post a New Load"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Route Details", Icons.route),
              const SizedBox(height: 15),
              _buildStyledField("Pickup Location", Icons.location_on_outlined, "City, State or Zip"),
              const SizedBox(height: 15),
              _buildStyledField("Drop-off Location", Icons.flag_outlined, "Destination City, State"),

              const SizedBox(height: 30),
              _buildSectionHeader("Cargo Information", Icons.inventory_2_outlined),
              const SizedBox(height: 15),
              _buildStyledField("Load Type", Icons.category_outlined, "e.g. Electronics, Furniture"),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildStyledField("Weight (kg)", Icons.scale_outlined, "500")),
                  const SizedBox(width: 15),
                  Expanded(child: _buildStyledField("Quantity", Icons.numbers, "20")),
                ],
              ),

              const SizedBox(height: 30),
              _buildSectionHeader("Budget & Date", Icons.payments_outlined),
              const SizedBox(height: 15),
              _buildStyledField("Estimated Budget (\$)", Icons.attach_money, "0.00", keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              _buildStyledField("Pickup Date", Icons.calendar_today_outlined, "YYYY-MM-DD"),

              const SizedBox(height: 40),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Load posted successfully! Now viewing bids.")),
                    );
                    Navigator.pushNamed(context, '/bidding_list');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text(
                    "Publish and View Bids",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStyledField(String label, IconData icon, String hint, {TextInputType? keyboardType}) {
    return TextFormField(
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        prefixIcon: Icon(icon, color: Colors.blueAccent.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }
}