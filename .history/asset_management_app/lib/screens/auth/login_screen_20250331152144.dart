import 'package:flutter/material.dart';
import 'package:asset_management_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart';
import 'signup_screen.dart';

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
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login Failed")));
    }
  }

  void loginWithGoogle() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: loginUser, child: const Text("Login")),
            ElevatedButton(onPressed: loginWithGoogle, child: const Text("Login with Google")),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
