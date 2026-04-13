import 'package:flutter/material.dart';
import 'package:cargolink_application/services/api_service.dart';

class CarrierDashboardScreen extends StatefulWidget {
  final String authToken; // Pass the token from the login screen
  const CarrierDashboardScreen({super.key, required this.authToken});

  @override
  State<CarrierDashboardScreen> createState() => _CarrierDashboardScreenState();
}

class _CarrierDashboardScreenState extends State<CarrierDashboardScreen> {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> fetchDashboardData() async {
    final summary = await _apiService.getDashboardSummaryData(widget.authToken);
    final bookings = await _apiService.getBookings(widget.authToken);
    final activeBooking = bookings.cast<Map<String, dynamic>?>().firstWhere(
      (booking) {
        if (booking == null) return false;
        const activeStatuses = {'Accepted', 'Picked_Up', 'In_Transit'};
        return activeStatuses.contains(booking['status']);
      },
      orElse: () => null,
    );

    return {
      'active_deliveries': summary['active_deliveries'] ?? 0,
      'completed_deliveries': summary['completed_deliveries'] ?? 0,
      'total_earnings': summary['total_earnings'] ?? 0,
      'pending_offers': summary['pending_offers'] ?? 0,
      'active_booking': activeBooking,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Carrier Dashboard", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/carrier_profile'),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          }

          // Real data from your Django backend
          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Operations Overview", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    _buildStatCard("Active", "${data['active_deliveries'] ?? 0}", Icons.local_shipping, Colors.orangeAccent,
                      onTap: () => Navigator.pushNamed(context, '/fleet'),
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard("Earnings", "\$${data['total_earnings'] ?? 0}", Icons.payments_outlined, Colors.greenAccent,
                      onTap: () => Navigator.pushNamed(context, '/carrier_wallet'),
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard("Offers", "${data['pending_offers'] ?? 0}", Icons.star_border, Colors.blueAccent),
                  ],
                ),

                const SizedBox(height: 30),

                // 2. Current Trip Section
                const Text("Live Trip", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildLiveTripCard(data['active_booking'] as Map<String, dynamic>?),

                const SizedBox(height: 30),

                // 3. Quick Actions
                const Text("Quick Actions", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _buildActionTile(Icons.search, "Find New Loads", "Browse available marketplace freight", Colors.blueAccent,
                  onTap: () => Navigator.pushNamed(context, '/load_board'),
                ),
                _buildActionTile(Icons.history, "Trip History", "View completed deliveries", Colors.white24,
                  onTap: () => Navigator.pushNamed(context, '/history'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Helper Methods ---

  Widget _buildStatCard(String label, String value, IconData icon, Color color, {void Function()? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteLine(String start, String end) {
    return Row(
      children: [
        Column(
          children: [
            const Icon(Icons.circle, color: Colors.blueAccent, size: 12),
            Container(height: 24, width: 1, color: Colors.white10),
            const Icon(Icons.location_on, color: Colors.redAccent, size: 12),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(start, style: const TextStyle(color: Colors.white, fontSize: 14)),
            const SizedBox(height: 25),
            Text(end, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildLiveTripCard(Map<String, dynamic>? booking) {
    if (booking == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: const Text(
          "No active delivery assigned yet.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    final status = (booking['status'] ?? 'Pending').toString().replaceAll('_', ' ');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Load #${booking['id']}",
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRouteLine(
            "Pickup: ${booking['pickup_location'] ?? 'Unknown'}",
            "Drop-off: ${booking['dropoff_location'] ?? 'Unknown'}",
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/active_trip'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text("Open GPS / Update Status", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, String sub, Color iconColor, {required void Function() onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white24),
        onTap: onTap,
      ),
    );
  }
}
