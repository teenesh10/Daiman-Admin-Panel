import 'package:admin_panel/constants.dart';
import 'package:admin_panel/controllers/auth_controller.dart';
import 'package:admin_panel/views/auth/login.dart';
import 'package:admin_panel/views/booking/booking.dart';
import 'package:admin_panel/views/dashboard/dashboard.dart';
import 'package:admin_panel/views/facility/add_facility_page.dart';
import 'package:admin_panel/views/facility/court/add_court_page.dart';
import 'package:admin_panel/views/facility/view_facility_page.dart';
import 'package:admin_panel/views/facility_rates/add_facility_rates.dart';
import 'package:admin_panel/views/facility_rates/view_facility_rates.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthController(),
        ),
        // Add more providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: bgColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          canvasColor: secondaryColor,
        ),
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardView());
      case '/facilities':
        return MaterialPageRoute(builder: (_) => const FacilityView());
      case '/add_facility':
        return MaterialPageRoute(builder: (_) => const AddFacilityPage());
      case '/add_court':
        return MaterialPageRoute(builder: (_) => const AddCourtPage());
      case '/facility_rates':
        return MaterialPageRoute(builder: (_) => const ViewFacilityRates());
      case '/add_facility_rates':
        final String selectedFacilityID = settings.arguments
            as String; 
        return MaterialPageRoute(
          builder: (_) =>
              AddFacilityRatePage(selectedFacilityID: selectedFacilityID),
        );
        case '/bookings':
        return MaterialPageRoute(builder: (_) => const ManageBookingView());
      // Add more routes here
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
