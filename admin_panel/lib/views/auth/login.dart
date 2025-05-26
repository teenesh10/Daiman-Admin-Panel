import 'package:admin_panel/controllers/auth_controller.dart';
import 'package:admin_panel/views/auth/forgot_password.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Login form
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
                     style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
                  // Password Input
                  TextFormField(
                    controller: authController.passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                     style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 16.0),
                  // Login Button
                  ElevatedButton(
                    onPressed: authController.isLoading
                        ? null
                        : () async {
                            final email =
                                authController.emailController.text.trim();
                            final password =
                                authController.passwordController.text.trim();

                            await authController.login(
                                email, password, context);
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
                            'Login',
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                  const SizedBox(height: 16.0),
                  // Forgot Password Link
                  TextButton(
                    onPressed: authController.isLoading
                        ? null
                        : () {
                            // Navigate to the Forgot Password page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordView()),
                            );
                          },
                    child: const Text(
                      'Forgot Password?',
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
