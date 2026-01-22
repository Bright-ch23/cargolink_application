import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Bids"),
              Tab(text: "Shipments"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotificationList(context, "all"),
            _buildNotificationList(context, "bids"),
            _buildNotificationList(context, "shipments"),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, String filter) {
    // Simulated data
    final notifications = [
      {
        "title": "New Bid Received",
        "body": "Alex Johnson placed a bid of \$850 on your Electronics load.",
        "time": "2 mins ago",
        "type": "bids",
        "isUnread": true,
        "icon": Icons.gavel,
      },
      {
        "title": "Shipment Picked Up",
        "body": "Your load #CL-88291 has been picked up from Virginia.",
        "time": "1 hour ago",
        "type": "shipments",
        "isUnread": true,
        "icon": Icons.local_shipping,
      },
      {
        "title": "Payment Confirmed",
        "body": "Your payment for load #CL-88291 was successful.",
        "time": "3 hours ago",
        "type": "all",
        "isUnread": false,
        "icon": Icons.check_circle,
      },
      {
        "title": "Driver Nearby",
        "body": "Robert Fox is 10 minutes away from the drop-off location.",
        "time": "5 hours ago",
        "type": "shipments",
        "isUnread": false,
        "icon": Icons.location_on,
      },
    ];

    // Simple filtering logic
    final filteredList = filter == "all"
        ? notifications
        : notifications.where((n) => n['type'] == filter).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return _buildNotificationItem(
          title: item['title'] as String,
          body: item['body'] as String,
          time: item['time'] as String,
          icon: item['icon'] as IconData,
          isUnread: item['isUnread'] as bool,
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String body,
    required String time,
    required IconData icon,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isUnread ? Colors.blueAccent.withOpacity(0.05) : Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isUnread ? Colors.blueAccent.withOpacity(0.2) : Colors.white10,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isUnread ? Colors.blueAccent : Colors.white10,
          child: Icon(icon, color: isUnread ? Colors.white : Colors.white54, size: 20),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Text(body, style: const TextStyle(color: Colors.white60, fontSize: 13)),
            const SizedBox(height: 8),
            Text(time, style: const TextStyle(color: Colors.white24, fontSize: 11)),
          ],
        ),
        onTap: () {
          // Logic to mark as read or navigate to specific load
        },
      ),
    );
  }
}