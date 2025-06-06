import 'package:admin_panel/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../controllers/manage_query_controller.dart';
import '../../../models/query.dart';

class PendingQueries extends StatefulWidget {
  const PendingQueries({super.key});

  @override
  State<PendingQueries> createState() => _PendingQueriesState();
}

class _PendingQueriesState extends State<PendingQueries> {
  final ManageQueryController _queryController = ManageQueryController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Pending Queries",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/queries');
              },
              child: const Text(
                "View All",
                style: TextStyle(color: primaryColor, fontSize: 14),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),

        // Live queries from Firestore
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: _queryController.getQueries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No pending queries");
            }

            // Filter pending and limit to 5
            final pendingQueries = snapshot.data!
                .where((q) => (q['status'] ?? '') == 'pending')
                .take(5)
                .toList();

            if (pendingQueries.isEmpty) {
              return const Text("No pending queries");
            }

            return Column(
              children: pendingQueries.map((queryMap) {
                final query = Query.fromMap(queryMap);
                return FutureBuilder<String>(
                  future: _queryController.getUserEmail(query.userID),
                  builder: (context, emailSnapshot) {
                    final email = emailSnapshot.data ?? 'Loading...';
                    return _buildQueryCard(
                      email: email,
                      message: query.report,
                      date: DateFormat('d MMM yyyy').format(query.date),
                    );
                  },
                );
              }).toList(),
            );
          },
        )
      ],
    );
  }

  Widget _buildQueryCard({
    required String email,
    required String message,
    required String date,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("📧 $email",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("📅 $date", style: const TextStyle(color: Colors.grey)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Pending",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
