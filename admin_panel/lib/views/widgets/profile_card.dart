// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:admin_panel/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class ProfileCard extends StatelessWidget {
  final AuthController authController;

  const ProfileCard({
    super.key,
    required this.authController,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              authController.signOut().then((_) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              });
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminEmail = authController.admin?.email ?? 'No Email';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 19,
            child: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: defaultPadding / 2),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              adminEmail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: defaultPadding / 4),
          PopupMenuButton<String>(
            icon: const Icon(Icons.keyboard_arrow_down),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              } else if (value == 'stripe_dashboard') {
                const url = 'https://dashboard.stripe.com/test/dashboard';
                html.window.open(url, '_blank');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'stripe_dashboard',
                child: Row(
                  children: [
                    Icon(Icons.open_in_new, color: primaryColor),
                    SizedBox(width: 10),
                    Text(
                      'Stripe Dashboard',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
