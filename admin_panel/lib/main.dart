import 'package:admin_panel/views/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDVsO30_Q_pOHrD4F0BHBBb_yTuk31oByI",
    projectId: "fyp-daiman",
    messagingSenderId: "95968883140",
    appId: "1:95968883140:web:2aed2205203908b3f3b491",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
       home: LoginView(), 
    );
  }
}
