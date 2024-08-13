// ignore_for_file: library_private_types_in_public_api

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
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: widget.isExpanded,
      backgroundColor: Colors.deepPurple.shade400,
      unselectedIconTheme: const IconThemeData(color: Colors.white, opacity: 1),
      unselectedLabelTextStyle: const TextStyle(color: Colors.white),
      selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text("Home"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.bar_chart),
          label: Text("Reports"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text("Profile"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text("Settings"),
        ),
      ],
      selectedIndex: 0,
      onDestinationSelected: (index) {
        // Handle navigation if needed
      },
    );
  }
}
