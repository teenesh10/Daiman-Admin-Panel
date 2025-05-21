import 'package:flutter/material.dart';

class SummaryCards extends StatelessWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryCard(
          color: Colors.blue,
          icon: Icons.sports_soccer,
          label: "Total Facilities",
          count: 12,
        ),
        _buildSummaryCard(
          color: Colors.green,
          icon: Icons.event_available,
          label: "Total Bookings",
          count: 87,
        ),
        _buildSummaryCard(
          color: Colors.deepPurple,
          icon: Icons.people,
          label: "Total Users",
          count: 34,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required Color color,
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$count",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
