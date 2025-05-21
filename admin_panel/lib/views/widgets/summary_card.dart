import 'package:flutter/material.dart';
import 'package:admin_panel/controllers/auth_controller.dart';
import 'package:admin_panel/controllers/manage_facility_controller.dart';
import 'package:admin_panel/controllers/manage_booking_controller.dart';
import 'package:admin_panel/models/facility.dart';
import 'package:admin_panel/models/booking.dart';

class SummaryCards extends StatefulWidget {
  const SummaryCards({super.key});

  @override
  State<SummaryCards> createState() => _SummaryCardsState();
}

class _SummaryCardsState extends State<SummaryCards> {
  int users = -1;

  final _facilityController = ManageFacilityController();
  final _bookingController = ManageBookingController();
  final _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final count = await _authController.getAllUsers();
    setState(() => users = count);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Facility Stream
        StreamBuilder<List<Facility>>(
          stream: _facilityController.getFacilities(),
          builder: (context, snapshot) {
            final count = snapshot.hasData ? snapshot.data!.length : -1;
            return _buildSummaryCard(
              color: Colors.blue,
              icon: Icons.sports_soccer,
              label: "Total Facilities",
              count: count,
            );
          },
        ),

        // Booking Stream
        StreamBuilder<List<Booking>>(
          stream: _bookingController.getBookings(),
          builder: (context, snapshot) {
            final count = snapshot.hasData ? snapshot.data!.length : -1;
            return _buildSummaryCard(
              color: Colors.green,
              icon: Icons.event_available,
              label: "Total Bookings",
              count: count,
            );
          },
        ),

        // User count (static)
        _buildSummaryCard(
          color: Colors.deepPurple,
          icon: Icons.people,
          label: "Total Users",
          count: users,
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
    final String display = count == -1 ? "N/A" : count.toString();

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
                  display,
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
