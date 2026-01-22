class DashboardStats {
  final int totalPosted;
  final int activeLoads;
  final int completed;
  final double totalSpent; // For Shippers
  final double totalEarnings; // For Carriers

  DashboardStats({
    required this.totalPosted,
    required this.activeLoads,
    required this.completed,
    this.totalSpent = 0.0,
    this.totalEarnings = 0.0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalPosted: json['total_posted'] ?? json['pending_offers'] ?? 0,
      activeLoads: json['active_loads'] ?? json['active_deliveries'] ?? 0,
      completed: json['completed'] ?? json['completed_deliveries'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0).toDouble(),
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
    );
  }
}
