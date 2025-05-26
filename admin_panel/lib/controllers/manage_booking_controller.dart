import 'package:admin_panel/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageBookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Booking>> getBookings() {
    return _firestore.collection('booking').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Booking.fromFirestore(data, doc.id);
      }).toList();
    });
  }
}
