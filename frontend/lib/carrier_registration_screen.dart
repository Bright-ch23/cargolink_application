import 'package:cargolink_application/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CarrierRegistrationScreen extends StatefulWidget {
  const CarrierRegistrationScreen({super.key});

  @override
  State<CarrierRegistrationScreen> createState() => _CarrierRegistrationScreenState();
}

class _CarrierRegistrationScreenState extends State<CarrierRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _nameController = TextEditingController(); // Used as 'username'
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _plateController = TextEditingController();
  final _payloadController = TextEditingController();
  final _carModelController = TextEditingController();
  final _carYearController = TextEditingController();
  final _carColorController = TextEditingController();

  String selectedTruckType = 'Flatbed';
  File? _licenseFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _plateController.dispose();
    _payloadController.dispose();
    _carModelController.dispose();
    _carYearController.dispose();
    _carColorController.dispose();
    super.dispose();
  }

  // ... (keeping your _pickLicense and _showPickerOptions as they were) ...

  void _handleCarrierRegister() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.')),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      // PROPOSED UPDATE: Clean the username to ensure Django accepts it
      // This replaces spaces with underscores: "John Doe" -> "John_Doe"
      String cleanUsername = _nameController.text.trim().replaceAll(' ', '_');

      final result = await ApiService().registerUser(
        username: cleanUsername,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        carModel: _carModelController.text.trim(),
        carYear: _carYearController.text.trim(),
        carColor: _carColorController.text.trim(),
      );

      if (result.containsKey('error') && result['error'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed: ${result['message']}')),
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/carrier_dashboard', (route) => false,
            arguments: result['token']
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("Carrier Setup")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account Credentials",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // UPDATED FIELD: Added isUsername flag
              _buildCarrierField(
                "Full Name",
                "e.g. John_Doe",
                controller: _nameController,
                isRequired: true,
                isUsername: true,
              ),

              const SizedBox(height: 20),
              _buildCarrierField("Email Address", "your.email@example.com", controller: _emailController, keyboardType: TextInputType.emailAddress, isRequired: true),
              const SizedBox(height: 20),
              _buildCarrierField("Phone Number", "+123456789", controller: _phoneController, keyboardType: TextInputType.phone, isRequired: true),
              const SizedBox(height: 20),
              _buildCarrierField(
                  "Password",
                  "Enter a strong password",
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  isRequired: true,
                  suffix: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  )
              ),

              const Divider(height: 50, color: Colors.white12),

              const Text("Vehicle Information", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildCarrierField("Car Model", "e.g. Toyota Camry", controller: _carModelController, isRequired: true),
              const SizedBox(height: 20),
              _buildCarrierField("Car Year", "e.g. 2021", controller: _carYearController, keyboardType: TextInputType.number, isRequired: true),
              const SizedBox(height: 20),
              _buildCarrierField("Car Color", "e.g. Blue", controller: _carColorController, isRequired: true),
              const SizedBox(height: 20),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleCarrierRegister,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Complete Registration"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // PROPOSED UPDATE: Helper method now includes regex validation
  Widget _buildCarrierField(
      String label,
      String hint, {
        TextEditingController? controller,
        TextInputType? keyboardType,
        bool obscureText = false,
        bool isRequired = false,
        bool isUsername = false,
        Widget? suffix
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: suffix,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.trim().isEmpty)) {
          return '$label is required';
        }

        // Validation for Django Username rules
        if (isUsername && value != null) {
          // Allows letters, numbers, and @/./+/-/_ but NO SPACES
          final usernameRegex = RegExp(r'^[a-zA-Z0-9@.+-_]+$');
          if (!usernameRegex.hasMatch(value)) {
            return 'Only letters, numbers, and @/./+/-/_ allowed';
          }
        }
        return null;
      },
    );
  }
}
