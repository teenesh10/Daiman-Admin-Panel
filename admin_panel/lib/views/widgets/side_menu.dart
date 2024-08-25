// side_menu.dart
// ignore_for_file: library_private_types_in_public_api

import 'package:admin_panel/views/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  final bool isExpanded;
  final ValueChanged<bool> onExpansionChanged;

  const SideMenu({
    super.key,
    required this.isExpanded,
    required this.onExpansionChanged,
  });

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0;

  final _pages = [
    const DashboardView(), // Replace with your actual pages
    // const FacilityView(),
    // Add other pages here if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple.shade400,
      child: Column(
        children: [
          // Logo and Admin Panel Text
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/logos/small_logo.png'), // Replace with your logo asset
                ),
                SizedBox(height: 10),
                Text(
                  "Daiman Admin Panel",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
         const Divider(color: Colors.white, thickness: 2),

          // Navigation Menu
          Expanded(
            child: NavigationRail(
              extended: widget.isExpanded,
              backgroundColor: Colors.transparent,
              unselectedIconTheme: const IconThemeData(color: Colors.white, opacity: 1),
              unselectedLabelTextStyle: const TextStyle(color: Colors.white),
              selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text("Dashboard"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart),
                  label: Text("Facilities"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text("Facility Rates"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text("Bookings"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text("Queries"),
                ),
              ],
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => _pages[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}