import 'package:admin_panel/constants.dart';
import 'package:admin_panel/controllers/auth_controller.dart';
import 'package:admin_panel/views/widgets/profile_card.dart';
import 'package:admin_panel/views/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Column(
      children: [
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          color: secondaryColor, // Use bgColor for the header background
          child: Row(
            children: [
              Text(
                authController.currentPage,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black), // White text color
              ),
              const Spacer(),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Adjust maxWidth as needed
                ),
                child: const SearchField(),
              ),
              const SizedBox(width: defaultPadding), // Add spacing between SearchField and ProfileCard
              ProfileCard(authController: authController), // Pass AuthController to ProfileCard
            ],
          ),
        ),
        Container(
          height: 1, // Thickness of the border
          color: Colors.black26, // Border color
        ),
      ],
    );
  }
}
