import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ActiveTripScreen extends StatefulWidget {
  const ActiveTripScreen({super.key});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  int _currentStep = 1;
  File? _podFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickPod(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _podFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking POD image: $e");
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F26),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.blueAccent),
              title: const Text("Gallery", style: TextStyle(color: Colors.white)),
              onTap: () {
                _pickPod(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
              title: const Text("Camera", style: TextStyle(color: Colors.white)),
              onTap: () {
                _pickPod(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Live Tracking"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.emergency_share, color: Colors.redAccent), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.white.withOpacity(0.05),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.navigation_rounded, color: Colors.blueAccent, size: 40),
                    const SizedBox(height: 10),
                    const Text("Map Integration: 4.2 mi to Destination", style: TextStyle(color: Colors.white60)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF1A1F26),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TRIP ID: #LD-5521", style: TextStyle(color: Colors.white24, fontSize: 12)),
                            Text("In Transit", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.phone, color: Colors.greenAccent),
                          style: IconButton.styleFrom(backgroundColor: Colors.greenAccent.withOpacity(0.1)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildStatusStep(0, "Pickup: Houston, TX", "Arrived at Jan 20, 08:12 AM", true),
                    _buildStatusStep(1, "On the Way", "Heading to Chicago, IL", _currentStep >= 1),
                    _buildStatusStep(2, "Drop-off: Chicago, IL", "Estimated Arrival: 4:00 PM", _currentStep >= 2),
                    const SizedBox(height: 30),
                    if (_currentStep < 2)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentStep++;
                            });
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                          child: Text(_currentStep == 0 ? "Confirm Pickup" : "Mark as Delivered"),
                        ),
                      ),
                    if (_currentStep == 2) _buildPodButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(int index, String title, String sub, bool isDone) {
    return Row(
      children: [
        Column(
          children: [
            Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDone ? Colors.blueAccent : Colors.white24, size: 24),
            if (index != 2) Container(width: 2, height: 40, color: isDone ? Colors.blueAccent : Colors.white10),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: isDone ? Colors.white : Colors.white24, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildPodButton() {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: _podFile == null ? Colors.blueAccent.withOpacity(0.5) : Colors.green.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(12),
          color: _podFile == null ? Colors.blueAccent.withOpacity(0.05) : Colors.green.withOpacity(0.1),
        ),
        child: _podFile == null
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text("Upload Proof of Delivery", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "POD Uploaded: ${_podFile!.path.split('/').last}",
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
