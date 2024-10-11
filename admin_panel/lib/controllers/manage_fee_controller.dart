import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_panel/models/fee.dart';

class ManageFeeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch facility rates from the subcollection under a specific facility
  Stream<List<Fee>> getFee(String facilityID) {
    return _firestore
        .collection('facility')
        .doc(facilityID)
        .collection('fee') // Subcollection for facility rates
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Fee.fromSnapshot(doc)).toList());
  }

  // Add a new facility rate to the subcollection under the specific facility
  Future<void> addFee(Fee fee) async {
    await _firestore
        .collection('facility')
        .doc(fee.facilityID)
        .collection('fee')
        .add(fee.toMap());
  }

  // Update an existing facility rate in the subcollection
  Future<void> updateFee(Fee fee) async {
    await FirebaseFirestore.instance
        .collection('facility')
        .doc(fee.facilityID) // This will now be correctly retrieved
        .collection('fee')
        .doc(fee.feeID)
        .update(fee.toMap());
  }

  // Delete a facility rate from the subcollection
  Future<void> deleteFee(String facilityID, String feeID) async {
    await _firestore
        .collection('facility')
        .doc(facilityID)
        .collection('fee')
        .doc(feeID)
        .delete();
  }
}
