// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:admin_panel/models/booking.dart';

void showBookingDetailsDialog(
  BuildContext context,
  Booking booking,
  Map<String, String> userInfo,
) {
  final userName = userInfo['username'] ?? 'Unknown';
  final userEmail = userInfo['email'] ?? 'Unknown';

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Row(
        children: [
          Icon(Icons.info_outline, color: primaryColor),
          SizedBox(width: 8),
          Text("Booking Details"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.person, "Username", userName),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.email, "Email", userEmail),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.calendar_today, "Date",
              DateFormat('yyyy-MM-dd').format(booking.startTime)),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.access_time, "Time",
              DateFormat('hh:mm a').format(booking.startTime)),
          const SizedBox(height: 8),
          _buildDetailRow(
              Icons.schedule, "Duration", "${booking.duration} hour(s)"),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.attach_money, "Amount Paid",
              "RM${booking.amountPaid.toStringAsFixed(2)}"),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.payment, "Payment Method",
              booking.paymentMethod.toUpperCase()),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}

Widget _buildDetailRow(IconData icon, String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18, color: Colors.grey[700]),
      const SizedBox(width: 8),
      Expanded(
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            children: [
              TextSpan(
                text: "$label: ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: value),
            ],
          ),
        ),
      ),
    ],
  );
}
