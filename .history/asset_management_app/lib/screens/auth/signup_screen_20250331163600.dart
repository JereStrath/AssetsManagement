import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asset_management_app/services/auth_service.dart';
import '../home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

 Future<void> signUpUser() async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
    return;
  }

  try {
    User? user = await _authService.signUp(
      emailController.text.trim(),
      passwordController.text.trim(),e
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Sign Up Failed")));
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Error: $e")));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: signUpUser, child: const Text("Sign Up")),
          ],
        ),
      ),
    );
  }
}
