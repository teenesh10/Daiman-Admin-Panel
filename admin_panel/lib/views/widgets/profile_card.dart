import 'package:admin_panel/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class ProfileCard extends StatelessWidget {
  final AuthController authController;

  const ProfileCard({
    super.key,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    final adminEmail = authController.admin?.email ?? 'No Email';
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensure the ProfileCard doesn't take up unnecessary space
        children: [
          CircleAvatar(
            child: const Icon(Icons.person),
            backgroundColor: Colors.grey[200],
            radius: 19,
          ),
          const SizedBox(width: defaultPadding / 2),
          ConstrainedBox( // Ensure the email doesn't overflow the space
            constraints: const BoxConstraints(maxWidth: 150), // Adjust maxWidth as needed
            child: Text(
              adminEmail,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
