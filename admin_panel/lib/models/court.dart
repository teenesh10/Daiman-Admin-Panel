import 'package:cloud_firestore/cloud_firestore.dart';

class Court {
  final String courtID;
  final String courtName;
  final String description;
  final bool availability; // true if available, false if booked

  Court({
    required this.courtID,
    required this.courtName,
    required this.description,
    required this.availability,
  });

  factory Court.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Court(
      courtID: doc.id,
      courtName: data['courtName'] ?? '',
      description: data['description'] ?? '',
      availability: data['availability'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courtName': courtName,
      'description': description,
      'availability': availability,
    };
  }
}
