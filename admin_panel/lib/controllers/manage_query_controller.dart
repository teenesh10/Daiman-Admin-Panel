import 'package:cloud_firestore/cloud_firestore.dart';

class ManageQueryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getQueries() {
    return _firestore.collection('query').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data()..['queryID'] = doc.id;
      }).toList();
    });
  }

  Future<void> deleteQuery(String queryID) async {
    await _firestore.collection('queries').doc(queryID).delete();
  }

  Future<void> resolveQuery(String queryID) async {
    await _firestore.collection('query').doc(queryID).update({
      'status': 'resolved',
    });
  }

  Future<String> getUserEmail(String userID) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(userID).get();
      return userDoc['email'] ?? 'Unknown';
    } catch (e) {
      print('Error fetching user email: $e');
      return 'Unknown';
    }
  }

  Future<void> sendEmailToUser(
      String email, String responseMessage, String queryID) async {
    try {
      // TODO: Later you will call your Cloud Function here
      print('Pretend sending email to $email: $responseMessage');

      // After sending email, mark as resolved
      await resolveQuery(queryID);
    } catch (e) {
      rethrow;
    }
  }
}
