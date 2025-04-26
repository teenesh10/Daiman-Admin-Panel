import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel/controllers/auth_controller.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authController =
        context.watch<AuthController>(); // Get AuthController

    return Drawer(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: ListView(
        children: [
          const DrawerHeader(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/logos/small_logo.png'),
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              authController.setPage("Dashboard");
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          DrawerListTile(
            title: "Facilities",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              authController.setPage("Facilities");
              Navigator.pushNamed(context, '/facilities');
            },
          ),
          DrawerListTile(
            title: "Facility Rates",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              authController.setPage("Facility Rates");
              Navigator.pushNamed(context, '/facility_rates');
            },
          ),
          DrawerListTile(
            title: "Bookings",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              authController.setPage("Bookings");
              Navigator.pushNamed(context, '/bookings');
            },
          ),
          DrawerListTile(
            title: "Queries",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              authController.setPage("Queries");
              Navigator.pushNamed(context, '/queries');
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
