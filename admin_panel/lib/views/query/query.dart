// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel/controllers/manage_query_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_panel/views/widgets/header.dart';
import 'package:admin_panel/views/widgets/side_menu.dart';
import 'package:intl/intl.dart';

class ManageQueryView extends StatefulWidget {
  const ManageQueryView({super.key});

  @override
  State<ManageQueryView> createState() => _ManageQueryViewState();
}

class _ManageQueryViewState extends State<ManageQueryView> {
  final ManageQueryController _controller = ManageQueryController();
  String _statusFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(flex: 1, child: SideMenu()),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                const Header(),
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 20),
                Expanded(child: _buildQueryTable()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Manage Queries", style: Theme.of(context).textTheme.titleLarge),
          Row(
            children: [
              DropdownButton<String>(
                value: _statusFilter,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                  DropdownMenuItem(
                      value: 'pending', child: Text('Pending Only')),
                  DropdownMenuItem(
                      value: 'resolved', child: Text('Resolved Only')),
                ],
                onChanged: (value) {
                  setState(() {
                    _statusFilter = value!;
                  });
                },
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Refresh'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQueryTable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _controller.getQueries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading queries: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No queries found'));
          }

          final filteredQueries = snapshot.data!.where((query) {
            final status = query['status'] ?? 'pending';
            return _statusFilter == 'all' || status == _statusFilter;
          }).toList()
            ..sort((a, b) {
              // Sort by status: 'pending' first, then 'resolved'
              final statusA = (a['status'] ?? 'pending') == 'pending' ? 0 : 1;
              final statusB = (b['status'] ?? 'pending') == 'pending' ? 0 : 1;

              if (statusA != statusB) {
                return statusA.compareTo(statusB); // pending before resolved
              }

              // If status is the same, sort by date descending (newest first)
              final dateA = (a['date'] as Timestamp?)?.toDate() ?? DateTime(0);
              final dateB = (b['date'] as Timestamp?)?.toDate() ?? DateTime(0);
              return dateB.compareTo(dateA);
            });

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columnSpacing: 30.0,
              headingRowColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.grey.shade200),
              columns: const [
                DataColumn(label: Text("#")),
                DataColumn(label: Text("Date")),
                DataColumn(label: Text("Message")),
                DataColumn(label: Text("Status")),
                DataColumn(label: Text("Actions")),
              ],
              rows: List.generate(filteredQueries.length, (index) {
                final query = filteredQueries[index];
                return DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text(formatDateOnly(query['date']))),
                    DataCell(
                      SizedBox(
                        width: 200,
                        child: Text(
                          query['report'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Chip(
                        label: Text(
                          (query['status'] ?? 'pending')
                              .toString()
                              .toUpperCase(),
                          style: TextStyle(
                            color: (query['status'] ?? 'pending') == 'pending'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        backgroundColor:
                            (query['status'] ?? 'pending') == 'pending'
                                ? Colors.red
                                : Colors.green.shade100,
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              _showQueryDetails(context, query);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              _confirmDelete(context, query['queryID']);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showQueryDetails(
      BuildContext context, Map<String, dynamic> query) async {
    final userEmail = await _controller.getUserEmail(query['userID']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Query Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: $userEmail'),
              Text('Date: ${formatDateOnly(query['date'])}'),
              const SizedBox(height: 20),
              const Text('Message:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(query['report'] ?? ''),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showRespondDialog(
                  userEmail, query['report'] ?? '', query['queryID']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Respond'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String queryID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
            'Are you sure you want to delete this query? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor, 
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _controller.deleteQuery(queryID);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Query deleted successfully')),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting query: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showRespondDialog(String email, String userMessage, String queryID) {
    final TextEditingController responseController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respond to User'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('To: $email'),
              const SizedBox(height: 10),
              const Text('Original Message:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(userMessage),
              const SizedBox(height: 20),
              TextField(
                controller: responseController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Your Response',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (responseController.text.isNotEmpty) {
                try {
                  await _controller.sendEmailToUser(
                      email, responseController.text, queryID);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Response sent and query marked as resolved')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error sending response: $e')),
                  );
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  String formatDateOnly(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('dd-MM-yyyy').format(timestamp.toDate());
    }
    return 'N/A';
  }
}
