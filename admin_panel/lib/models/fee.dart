import 'package:cloud_firestore/cloud_firestore.dart';

class Fee {
  final String feeID;
  final String facilityID;
  final double weekdayRate;
  final double weekendRate;
  final String description;

  Fee({
    required this.feeID,
    required this.facilityID,
    required this.weekdayRate,
    required this.weekendRate,
    required this.description,
  });

  // Convert Firestore document to Fee object with safe parsing
  factory Fee.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Document data is null for Fee with ID: ${snapshot.id}");
    }

    final weekdayRate = (data['weekdayRate'] is String)
        ? double.tryParse(data['weekdayRate']) ?? 0.0
        : (data['weekdayRate'] ?? 0.0).toDouble();

    final weekendRate = (data['weekendRate'] is String)
        ? double.tryParse(data['weekendRate']) ?? 0.0
        : (data['weekendRate'] ?? 0.0).toDouble();

    return Fee(
      feeID: snapshot.id,
      facilityID: data['facilityID'] ?? 'Unknown',
      weekdayRate: weekdayRate,
      weekendRate: weekendRate,
      description: data['description'],
    );
  }

  // Convert Fee object to a map to send to Firestore
  Map<String, dynamic> toMap() {
    return {
      'facilityID': facilityID,
      'weekdayRate': weekdayRate,
      'weekendRate': weekendRate,
      'description': description,
    };
  }
}
