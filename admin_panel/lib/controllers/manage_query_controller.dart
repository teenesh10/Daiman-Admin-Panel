import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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

  // Future<void> sendEmailToUser(
  //     String email, String responseMessage, String queryID) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   await user?.getIdToken(true); // Force refresh

  //   try {
  //     final HttpsCallable callable =
  //         FirebaseFunctions.instance.httpsCallable('sendEmailResponse');

  //     final result = await callable.call(<String, dynamic>{
  //       'email': email,
  //       'responseMessage': responseMessage,
  //     });

  //     if (result.data['success'] == true) {
  //       print('Email sent to $email');
  //       await resolveQuery(queryID);
  //     } else {
  //       print('Email function did not return success');
  //     }
  //   } on FirebaseFunctionsException catch (e) {
  //     print('Cloud Function error: ${e.code} - ${e.message}');
  //     rethrow;
  //   } catch (e) {
  //     print('Unknown error: $e');
  //     rethrow;
  //   }
  // }

  Future<void> sendEmailToUser(
    String email, String responseMessage, String queryID) async {
  final user = FirebaseAuth.instance.currentUser;
  final idToken = await user?.getIdToken(true); // force refresh

  final response = await http.post(
    Uri.parse('https://sendemailresponse-d7u4qgi7fa-uc.a.run.app/sendEmailResponse'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'responseMessage': responseMessage,
    }),
  );

  if (response.statusCode == 200) {
    print('Email sent');
    await resolveQuery(queryID);
  } else {
    print('Email failed: ${response.body}');
  }
}
}
