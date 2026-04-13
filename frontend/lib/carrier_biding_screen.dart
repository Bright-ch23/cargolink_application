import 'package:flutter/material.dart';
import 'package:cargolink_application/services/api_service.dart';

class CarrierBiddingScreen extends StatefulWidget {
  final String token;
  final String bookingId;
  final String loadTitle;

  const CarrierBiddingScreen({
    super.key,
    required this.token,
    required this.bookingId,
    required this.loadTitle,
  });

  @override
  State<CarrierBiddingScreen> createState() => _CarrierBiddingScreenState();
}

class _CarrierBiddingScreenState extends State<CarrierBiddingScreen> {
  late Future<List<Map<String, dynamic>>> _bidsFuture;

  @override
  void initState() {
    super.initState();
    _bidsFuture = ApiService().getBookingBids(token: widget.token, bookingId: widget.bookingId);
  }

  Future<void> _refresh() async {
    setState(() {
      _bidsFuture = ApiService().getBookingBids(token: widget.token, bookingId: widget.bookingId);
    });
  }

  Future<void> _respondToBid(String bidId, String action) async {
    final result = await ApiService().respondToBid(
      token: widget.token,
      bidId: bidId,
      action: action,
    );

    if (!mounted) return;

    if (result['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to $action bid: ${result['message']}")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Bid ${action}ed successfully.")),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Incoming Bids", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Load: ${widget.loadTitle}", style: const TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bidsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          }

          final bids = snapshot.data ?? [];
          if (bids.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Center(child: Text("No bids yet for this load.", style: TextStyle(color: Colors.white70))),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: bids.map((bid) => _buildBidCard(context, bid: bid)).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBidCard(BuildContext context, {required Map<String, dynamic> bid}) {
    final status = bid['status'] ?? 'Pending';
    final isPending = status == 'Pending';
    final carrierName = bid['carrier_name'] ?? 'Carrier';
    final price = bid['amount']?.toString() ?? '0';
    final createdAt = bid['created_at']?.toString().replaceFirst('T', ' ').substring(0, 16) ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F26),
        borderRadius: BorderRadius.circular(20),
        border: isPending
            ? Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2)
            : Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white10,
                  child: Text(carrierName[0], style: const TextStyle(color: Colors.blueAccent)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(carrierName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        bid['message']?.toString().isNotEmpty == true ? bid['message'] : "No note from carrier",
                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("\$$price", style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(status, style: const TextStyle(color: Colors.white30, fontSize: 10)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(createdAt, style: const TextStyle(color: Colors.white38, fontSize: 12)),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: isPending ? () => _respondToBid(bid['id'].toString(), 'decline') : null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Decline", style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: isPending ? () => _respondToBid(bid['id'].toString(), 'accept') : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Accept Bid"),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
