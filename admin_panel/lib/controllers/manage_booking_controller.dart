import 'package:admin_panel/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageBookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Booking>> getBookings() {
    return _firestore.collection('bookings').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Booking.fromFirestore(doc.data() as DocumentSnapshot<Object?>)).toList();
    });
  }
}
