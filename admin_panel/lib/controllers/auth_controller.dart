// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel/models/admin.dart';
import 'package:admin_panel/views/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add TextEditingController instances for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Admin? _admin;
  Admin? get admin => _admin;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _currentPage = "Dashboard";
  String get currentPage => _currentPage;

  // Method to log in an admin
  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = "Please fill in all fields.";
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch admin data from Firestore
      DocumentSnapshot adminDoc = await _firestore
          .collection('admin')
          .doc(userCredential.user!.uid)
          .get();

      if (!adminDoc.exists) {
        throw Exception('No admin found for the provided credentials.');
      }

      // Parse the admin data
      _admin = Admin.fromDocumentSnapshot(
          adminDoc.data() as Map<String, dynamic>, adminDoc.id);

      _errorMessage = null; // Clear any previous error messages
      notifyListeners();

      // Redirect to dashboard page upon successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        _errorMessage = "Invalid email or password.";
      } else if (e.code == 'invalid-email') {
        _errorMessage = "The email address is not valid.";
      } else {
        _errorMessage = e.message;
      }
      notifyListeners();
    } catch (e) {
      // Handle other errors (e.g., no admin found)
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to reset password
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      if (email.isEmpty) {
        _errorMessage = "Please enter your email address.";
        notifyListeners();
        return;
      }

      _isLoading = true;
      notifyListeners();

      // Check if the email exists in the admin collection
      final querySnapshot = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _errorMessage = "No admin found with this email address.";
        notifyListeners();
        _isLoading = false;
        return;
      }

      // Send password reset email
      await _auth.sendPasswordResetEmail(email: email);

      _errorMessage = null; // Clear any previous error messages

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent to $email")),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase errors
      if (e.code == 'user-not-found') {
        _errorMessage = "No user found with this email address.";
      } else if (e.code == 'invalid-email') {
        _errorMessage = "The email address is not valid.";
      } else {
        _errorMessage = e.message;
      }
      notifyListeners();
    } catch (e) {
      // Handle other errors
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method to sign out the user
  Future<void> signOut() async {
    await _auth.signOut();
    _admin = null;
    notifyListeners();
  }

  // Clear error messages
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  // Method to update the current page
  void setPage(String pageName) {
    if (_currentPage != pageName) {
      _currentPage = pageName;
      notifyListeners(); // Trigger rebuild only when needed
    }
  }

  Future<int> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('user').get();
      return snapshot.size;
    } catch (e) {
      return -1; // Use -1 to indicate error
    }
  }

  @override
  void dispose() {
    // Dispose controllers when they are no longer needed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
