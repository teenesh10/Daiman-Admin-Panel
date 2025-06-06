import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_panel/controllers/auth_controller.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final currentPage = authController.currentPage;

    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/logos/small_logo.png'),
              ),
            ),

            const Divider(
              color: Colors.white24,
              thickness: 1,
              height: 1,
            ),

            const SizedBox(height: 12),

            // Menu Items
            DrawerListTile(
              title: "Dashboard",
              icon: Icons.dashboard_outlined,
              selected: currentPage == "Dashboard",
              onTap: () {
                authController.setPage("Dashboard");
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            DrawerListTile(
              title: "Facilities",
              icon: Icons.sports_soccer,
              selected: currentPage == "Facilities",
              onTap: () {
                authController.setPage("Facilities");
                Navigator.pushNamed(context, '/facilities');
              },
            ),
            DrawerListTile(
              title: "Facility Rates",
              icon: Icons.attach_money_outlined,
              selected: currentPage == "Facility Rates",
              onTap: () {
                authController.setPage("Facility Rates");
                Navigator.pushNamed(context, '/facility_rates');
              },
            ),
            DrawerListTile(
              title: "Bookings",
              icon: Icons.event_available_outlined,
              selected: currentPage == "Bookings",
              onTap: () {
                authController.setPage("Bookings");
                Navigator.pushNamed(context, '/bookings');
              },
            ),
            DrawerListTile(
              title: "Queries",
              icon: Icons.question_answer_outlined,
              selected: currentPage == "Queries",
              onTap: () {
                authController.setPage("Queries");
                Navigator.pushNamed(context, '/queries');
              },
            ),

            const Spacer(),

            const Divider(
              color: Colors.white24,
              thickness: 1,
              height: 1,
            ),

            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Text(
                '© 2025 Daiman Sri Skudai',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool selected;

  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white10 : Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: selected ? Colors.white : Colors.white54,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white54,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
