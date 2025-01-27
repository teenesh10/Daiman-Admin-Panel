import 'package:cloud_firestore/cloud_firestore.dart';

class Fee {
  final String feeID;
  final String facilityID;
  final double weekdayRateBefore6;
  final double weekdayRateAfter6;
  final double weekendRateBefore6;
  final double weekendRateAfter6;
  final String description;

  Fee({
    required this.feeID,
    required this.facilityID,
    required this.weekdayRateBefore6,
    required this.weekdayRateAfter6,
    required this.weekendRateBefore6,
    required this.weekendRateAfter6,
    required this.description,
  });

  // Convert Firestore document to Fee object with safe parsing
  factory Fee.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Document data is null for Fee with ID: ${snapshot.id}");
    }

    // Extract facilityID from the document path
    final facilityID = snapshot.reference.parent.parent?.id ?? 'Unknown';

    double parseRate(dynamic value) {
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return (value ?? 0.0).toDouble();
    }

    return Fee(
      feeID: snapshot.id,
      facilityID: facilityID,
      weekdayRateBefore6: parseRate(data['weekdayRateBefore6']),
      weekdayRateAfter6: parseRate(data['weekdayRateAfter6']),
      weekendRateBefore6: parseRate(data['weekendRateBefore6']),
      weekendRateAfter6: parseRate(data['weekendRateAfter6']),
      description: data['description'] ?? '',
    );
  }

  // Convert Fee object to a map to send to Firestore
  Map<String, dynamic> toMap() {
    return {
      'facilityID': facilityID,
      'weekdayRateBefore6': weekdayRateBefore6,
      'weekdayRateAfter6': weekdayRateAfter6,
      'weekendRateBefore6': weekendRateBefore6,
      'weekendRateAfter6': weekendRateAfter6,
      'description': description,
    };
  }
}
