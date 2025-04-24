import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/custom_drawer.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(), // Side menu with role-based navigation
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to User Dashboard!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (user != null)
              Text(
                "Logged in as: ${user.email}",
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/assets');
              },
              child: const Text("View My Assets"),
            ),
          ],
        ),
      ),
    );
  }
}
