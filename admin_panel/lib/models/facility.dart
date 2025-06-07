import 'package:cloud_firestore/cloud_firestore.dart';

class Facility {
  String facilityID;
  String facilityName;
  int capacity;
  String description;

  Facility({
    required this.facilityID,
    required this.facilityName,
    required this.capacity,
    required this.description,
  });

  factory Facility.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Facility(
      facilityID: doc.id,
      facilityName: data['facilityName'],
      capacity: data['capacity'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'facilityName': facilityName,
      'capacity': capacity,
      'description': description,
    };
  }
}
