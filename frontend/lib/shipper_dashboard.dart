import 'package:flutter/material.dart';
import 'package:cargolink_application/services/api_service.dart';

class ShipperDashboard extends StatefulWidget {
  final String username;
  final String token;

  const ShipperDashboard({super.key, required this.username, required this.token});

  @override
  State<ShipperDashboard> createState() => _ShipperDashboardState();
}

class _ShipperDashboardState extends State<ShipperDashboard> {
  late Future<Map<String, dynamic>> _dashboardData;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _dashboardData = fetchDashboardData();
  }

  Future<Map<String, dynamic>> fetchDashboardData() async {
    try {
      final summary = await _apiService.getDashboardSummaryData(widget.token);
      final bookings = await _apiService.getBookings(widget.token);

      return {
        'summary': summary,
        'bookings': bookings,
      };
    } catch (e) {
      throw Exception("Connection failed: $e");
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _dashboardData = fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Shipper Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/shipper_profile'),
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.blueAccent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hello, ${widget.username}!",
                  style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 5),
              const Text("Manage your shipments",
                  style: TextStyle(color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),

              FutureBuilder<Map<String, dynamic>>(
                future: _dashboardData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                          child: CircularProgressIndicator(color: Colors
                              .blueAccent)),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text("Error: ${snapshot.error}",
                          style: const TextStyle(color: Colors.redAccent)),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final summary = (data['summary'] as Map<String, dynamic>?) ?? {};
                    final bookings = (data['bookings'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
                    final totalPosted = summary['total_posted'] ?? 0;
                    final activeLoads = summary['active_loads'] ?? 0;
                    final completed = summary['completed'] ?? 0;
                    final totalSpent = (summary['total_spent'] ?? 0.0).toDouble();

                    return Column(
                      children: [
                        Row(
                          children: [
                            _buildStatusCard(
                                "Total Posted", totalPosted.toString(),
                                Colors.purpleAccent,
                                Icons.inventory_2_outlined),
                            const SizedBox(width: 15),
                            _buildStatusCard("Active", activeLoads.toString(),
                                Colors.blueAccent, Icons.local_shipping),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            _buildStatusCard("Completed", completed.toString(),
                                Colors.green, Icons.check_circle_outline),
                            const SizedBox(width: 15),
                            _buildStatusCard("Total Spent",
                                "\$${totalSpent.toStringAsFixed(2)}",
                                Colors.amber, Icons.monetization_on_outlined),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Recent Shipments",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            TextButton(
                              onPressed: _refreshData,
                              child: const Text("Refresh",
                                  style: TextStyle(color: Colors.blueAccent)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (bookings.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "No shipments yet. Post your first load to see live dashboard data here.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        else
                          ...bookings.take(5).map((booking) => _buildShipmentItem(
                            context,
                            booking['id'].toString(),
                            booking['cargo_type'] ?? 'Cargo',
                            booking['pickup_location'] ?? 'Unknown origin',
                            booking['dropoff_location'] ?? 'Unknown destination',
                            _formatStatus(booking['status'] ?? 'Pending'),
                          )),
                      ],
                    );
                  }
                  return const Text(
                      "No data found.", style: TextStyle(color: Colors.white));
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.pushNamed(
            context,
            '/post_load',
            arguments: {'token': widget.token},
          );
          if (created == true) {
            _refreshData();
          }
        },
        backgroundColor: Colors.blueAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
            "New Shipment", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 15),
            Text(value,
                style: const TextStyle(color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            Text(title,
                style: const TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentItem(BuildContext context, String id, String title, String from, String to, String status) {
    return GestureDetector(
      onTap: () {
        final bookingPk = int.tryParse(id);

        if (status == "In Transit" && bookingPk != null) {
          Navigator.pushNamed(
            context,
            '/tracking',
            arguments: {
              'bookingId': bookingPk.toString(),
              'token': widget.token,
            },
          );
        } else if (bookingPk != null) {
          Navigator.pushNamed(
            context,
            '/bidding_list',
            arguments: {
              'token': widget.token,
              'bookingId': bookingPk.toString(),
              'loadTitle': title,
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
                "This item is not linked to a real booking yet.")),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                  Icons.inventory_2_outlined, color: Colors.blueAccent),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("$from → $to", style: const TextStyle(
                      color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: status == "In Transit" ? Colors.blueAccent.withOpacity(
                    0.2) : Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: status == "In Transit" ? Colors.blueAccent : Colors
                      .white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(String status) {
    return status.replaceAll('_', ' ');
  }
}
