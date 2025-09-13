import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_panel/config/app_config.dart';

class ManageQueryController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Returns a real-time stream of all queries with their queryID included.
  Stream<List<Map<String, dynamic>>> getQueries() {
    return _firestore.collection('query').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['queryID'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Deletes a query by its document ID.
  Future<void> deleteQuery(String queryID) async {
    await _firestore.collection('query').doc(queryID).delete();
  }

  // Marks a query as resolved in Firestore.
  Future<void> resolveQuery(String queryID) async {
    await _firestore.collection('query').doc(queryID).update({
      'status': 'resolved',
    });
  }

  // Retrieves the email address of a user given their user ID.
  // Returns 'Unknown' if the user or email field doesn't exist.
  Future<String> getUserEmail(String userID) async {
    try {
      final userDoc = await _firestore.collection('user').doc(userID).get();
      return userDoc.data()?['email'] ?? 'Unknown';
    } catch (_) {
      return 'Unknown';
    }
  }

  // Sends an email response to the user via a backend HTTP endpoint.
  // Resolves the query if the email was sent successfully.
  Future<void> sendEmailToUser(
      String email, String message, String queryID) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No authenticated user");

      final idToken = await user.getIdToken(true);

      final response = await http.post(
        Uri.parse('${AppConfig.firebaseFunctionsUrl}/sendEmailResponse'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        await resolveQuery(queryID);
      } else {
        throw Exception('Failed to send email: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
