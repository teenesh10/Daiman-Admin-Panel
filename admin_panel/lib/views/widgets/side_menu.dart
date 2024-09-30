import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel/controllers/auth_controller.dart'; // Import AuthController

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>(); // Get AuthController

    return Drawer(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)), // Remove rounded corners
      ),
      child: ListView(
        children: [
          const DrawerHeader(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/logos/small_logo.png'), // Replace with your logo asset
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              authController.setPage("Dashboard"); // Update the current page
              Navigator.pushNamed(context, '/dashboard'); // Navigate to the dashboard page
            },
          ),
          DrawerListTile(
            title: "Facilities",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              authController.setPage("Facilities"); // Update the current page
              Navigator.pushNamed(context, '/facilities'); // Navigate to facilities page
            },
          ),
          DrawerListTile(
            title: "Facility Rates",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              authController.setPage("Facility Rates"); // Update the current page
              Navigator.pushNamed(context, '/facility_rates'); // Navigate to task page
            },
          ),
          DrawerListTile(
            title: "Bookings",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              authController.setPage("Documents"); // Update the current page
              Navigator.pushNamed(context, '/documents'); // Navigate to documents page
            },
          ),
          DrawerListTile(
            title: "Queries",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              authController.setPage("Store"); // Update the current page
              Navigator.pushNamed(context, '/store'); // Navigate to store page
            },
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              authController.setPage("Settings"); // Update the current page
              Navigator.pushNamed(context, '/settings'); // Navigate to settings page
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
