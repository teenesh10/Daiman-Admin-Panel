import 'package:cloud_firestore/cloud_firestore.dart';

class Query {
  final String queryID;
  final String userID;
  final DateTime date;
  final String report;
  final String status;

  Query({
    required this.queryID,
    required this.userID,
    required this.date,
    required this.report,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'queryID': queryID,
      'userID': userID,
      'date': date,
      'report': report,
      'status': status,
    };
  }

  factory Query.fromMap(Map<String, dynamic> map) {
    return Query(
      queryID: map['queryID'] as String? ?? '',
      userID: map['userID'] as String? ?? '',
      date: (map['date'] as Timestamp).toDate(),
      report: map['report'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
    );
  }
}
