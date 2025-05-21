import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    await _firestore.collection('query').doc(queryID).delete();
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
      String email, String message, String queryID) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No authenticated user");
      }

      final idToken = await user.getIdToken(true);

      final response = await http.post(
        Uri.parse('https://sendemailresponse-d7u4qgi7fa-uc.a.run.app'),
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
        print('Email sent successfully!');
        await resolveQuery(queryID);
      } else {
        print('Failed to send email. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to send email: ${response.body}');
      }
    } catch (e) {
      print('Error in sendEmailToUser: $e');
      rethrow;
    }
  }
}
