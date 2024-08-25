import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final bool isSmallScreen;
  final VoidCallback onSignOut;

  const Header({
    super.key,
    required this.onMenuPressed,
    required this.isSmallScreen,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isSmallScreen)
            IconButton(
              onPressed: onMenuPressed,
              icon: const Icon(Icons.menu),
            ),
          if (!isSmallScreen)
            const Text(
              'Daiman Admin Panel', // You can add a title or logo here if needed
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          GestureDetector(
            onTap: () {
              // Handle avatar tap, e.g., navigate to user profile or settings
            },
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'sign_out') {
                  onSignOut();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'sign_out',
                    child: Text('Sign Out'),
                  ),
                ];
              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://faces-img.xcdn.link/image-lorem-face-3430.jpg"),
                radius: 26.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
