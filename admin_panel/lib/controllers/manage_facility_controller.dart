import 'package:admin_panel/models/court.dart';
import 'package:admin_panel/models/facility.dart';
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
        .collection('court')
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
        .collection('court')
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
        .collection('court')
        .add(court.toFirestore());
  }

  // Delete a specific court
  Future<void> deleteCourt(String facilityId, String courtId) async {
    await _firestore
        .collection('facility')
        .doc(facilityId)
        .collection('court')
        .doc(courtId)
        .delete();
  }

  // Fetch details of a specific facility
  Future<Facility> getFacilityDetails(String facilityId) async {
    final doc = await _firestore.collection('facility').doc(facilityId).get();
    return Facility.fromFirestore(doc);
  }

  // Add a new facility and return the document reference
  Future<DocumentReference> addFacility(Facility facility) async {
    return await _firestore.collection('facility').add(facility.toFirestore());
  }


  // Update an existing facility
  Future<void> updateFacility(Facility updatedFacility) async {
    await _firestore
        .collection('facility')
        .doc(updatedFacility.facilityID) // Ensure that Facility model has an id field
        .update(updatedFacility.toFirestore());
  }
}
