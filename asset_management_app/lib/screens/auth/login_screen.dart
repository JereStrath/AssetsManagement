import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asset_management_app/services/auth_service.dart';
import 'signup_screen.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void loginUser() async {
    User? user = await _authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
  }

  void googleLogin() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Google Sign-In Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top background + logo
            Container(
              height: size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'), // Add this pattern in your assets
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/logo.png', // Add your logo here
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Bottom white container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "Sign in to continue.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text("NAME", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text("PASSWORD", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: googleLogin,
                          child: const Text(
                            "Login with google",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Signup !",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
