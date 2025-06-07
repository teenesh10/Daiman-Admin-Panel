// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel/models/admin.dart';
import 'package:admin_panel/views/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  /// Logs in an admin using Firebase Auth and retrieves admin data from Firestore.
  Future<void> login(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Please fill in all fields.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Attempt sign in
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch admin document from Firestore
      final adminDoc = await _firestore
          .collection('admin')
          .doc(userCredential.user!.uid)
          .get();

      if (!adminDoc.exists) {
        _errorMessage = "No admin found for the provided credentials.";
        notifyListeners();
        return;
      }

      // Parse admin data
      _admin = Admin.fromDocumentSnapshot(
        adminDoc.data() as Map<String, dynamic>,
        adminDoc.id,
      );

      _errorMessage = null;
      notifyListeners();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        _errorMessage = "Invalid email address or password.";
      } else if (e.code == 'invalid-email') {
        _errorMessage = "The email address is not valid.";
      } else {
        _errorMessage = "Login failed. Please try again.";
      }
      notifyListeners();
    } catch (_) {
      _errorMessage = "Login failed. Please check your email and password.";
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sends a password reset email if the admin email exists in Firestore.
  Future<void> resetPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      _errorMessage = "Please enter your email address.";
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Check if the email exists in admin collection
      final querySnapshot = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _errorMessage = "No admin found with this email address.";
        notifyListeners();
        return;
      }

      // Send reset email
      await _auth.sendPasswordResetEmail(email: email);

      _errorMessage = null;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password reset email sent to $email"),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        _errorMessage = "Invalid or unregistered email address.";
      } else {
        _errorMessage = "Password reset failed. Please try again.";
      }
      notifyListeners();
    } catch (_) {
      _errorMessage = "Something went wrong. Please try again.";
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Signs out the current admin.
  Future<void> signOut() async {
    await _auth.signOut();
    _admin = null;
    notifyListeners();
  }

  // Clears any existing error messages.
  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  // Sets the current page for navigation control.
  void setPage(String pageName) {
    if (_currentPage != pageName) {
      _currentPage = pageName;
      notifyListeners();
    }
  }

  // Returns total number of users from Firestore.
  Future<int> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('user').get();
      return snapshot.size;
    } catch (_) {
      return -1; // Indicates error
    }
  }

  // Disposes controllers when no longer needed.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
