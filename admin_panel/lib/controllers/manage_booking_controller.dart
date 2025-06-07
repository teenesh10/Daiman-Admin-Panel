import 'package:admin_panel/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageBookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Returns a real-time stream of all bookings from Firestore.
  Stream<List<Booking>> getBookings() {
    return _firestore.collection('booking').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data());
      }).toList();
    });
  }

  // Retrieves user details (username and email) for a given user ID.
  // Returns 'Unknown' if user not found or if there's an error.
  Future<Map<String, String>> getBookingUserDetails(String userID) async {
    try {
      final userDoc = await _firestore.collection('user').doc(userID).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        return {
          'username': data['username'] ?? 'Unknown',
          'email': data['email'] ?? 'Unknown',
        };
      }
    } catch (_) {
      // Fall through to return unknowns
    }

    return {
      'username': 'Unknown',
      'email': 'Unknown',
    };
  }
}
