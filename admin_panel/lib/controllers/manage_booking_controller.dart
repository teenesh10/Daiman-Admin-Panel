import 'package:admin_panel/models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageBookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Booking>> getBookings() {
    return _firestore.collection('booking').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Booking.fromMap(data);
      }).toList();
    });
  }

  Future<Map<String, String>> getBookingUserDetails(String userID) async {
    try {
      final userSnapshot =
          await _firestore.collection('user').doc(userID).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data()!;
        return {
          'username': userData['username'] ?? 'Unknown',
          'email': userData['email'] ?? 'Unknown',
        };
      } else {
        return {
          'username': 'Unknown',
          'email': 'Unknown',
        };
      }
    } catch (e) {
      return {
        'username': 'Unknown',
        'email': 'Unknown',
      };
    }
  }
}
