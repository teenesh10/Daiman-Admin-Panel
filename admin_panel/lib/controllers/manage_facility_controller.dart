import 'package:cloud_firestore/cloud_firestore.dart';

class ManageFacilityController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the list of facilities
  Stream<List<Facility>> getFacilities() {
    return _firestore.collection('facility').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Facility.fromFirestore(doc);
      }).toList();
    });
  }

  // Delete a specific facility
  Future<void> deleteFacility(String facilityId) async {
    // Delete all courts under the facility first
    final courtsSnapshot = await _firestore
        .collection('facility')
        .doc(facilityId)
        .collection('courts')
        .get();

    for (var doc in courtsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Delete the facility document itself
    await _firestore.collection('facility').doc(facilityId).delete();
  }

  // Fetch the list of courts for a specific facility
  Stream<List<Court>> getCourtsForFacility(String facilityId) {
    return _firestore
        .collection('facility')
        .doc(facilityId)
        .collection('courts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Court.fromFirestore(doc);
      }).toList();
    });
  }

  // Add a new court to a specific facility
  Future<void> addCourt(String facilityId, Court court) async {
    await _firestore
        .collection('facility')
        .doc(facilityId)
        .collection('courts')
        .add(court.toFirestore());
  }

  // Delete a specific court
  Future<void> deleteCourt(String facilityId, String courtId) async {
    await _firestore
        .collection('facility')
        .doc(facilityId)
        .collection('courts')
        .doc(courtId)
        .delete();
  }

  // Fetch details of a specific facility (optional)
  Future<Facility> getFacilityDetails(String facilityId) async {
    final doc = await _firestore.collection('facility').doc(facilityId).get();
    return Facility.fromFirestore(doc);
  }
}

class Court {
  final String courtId;
  final String courtName;
  final String description;

  Court({
    required this.courtId,
    required this.courtName,
    required this.description,
  });

  factory Court.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Court(
      courtId: doc.id,
      courtName: data['courtName'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courtName': courtName,
      'description': description,
    };
  }
}

class Facility {
  final String facilityId;
  final String facilityName;
  final int capacity;

  Facility({
    required this.facilityId,
    required this.facilityName,
    required this.capacity,
  });

  factory Facility.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Facility(
      facilityId: doc.id,
      facilityName: data['facilityName'] ?? '',
      capacity: data['capacity'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'facilityName': facilityName,
      'capacity': capacity,
    };
  }
}
