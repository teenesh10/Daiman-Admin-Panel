import 'package:admin_panel/controllers/auth_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    // Determine screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/daiman_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Forgot Password Form
          Center(
            child: Container(
              width: isMobile ? screenWidth * 0.9 : 400,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logos/daiman_logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 16.0),
                  // Error Message
                  if (authController.errorMessage != null) ...[
                    Text(
                      authController.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                  // Email Input
                  TextFormField(
                    controller: authController.emailController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Reset Password Button
                  ElevatedButton(
                    onPressed: authController.isLoading
                        ? null
                        : () async {
                            final email =
                                authController.emailController.text.trim();

                            await authController.resetPassword(email, context);
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: authController.isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                        : const Text(
                            'Reset Password',
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                  const SizedBox(height: 16.0),
                  // Back to Login Link
                  TextButton(
                    onPressed: authController.isLoading
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
