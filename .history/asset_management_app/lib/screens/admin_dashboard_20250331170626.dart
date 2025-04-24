import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String? userRole;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userRole = userDoc['role'];
        isLoading = false;
      });

      // Redirect non-admin users
      if (userRole != "admin") {
        Future.microtask(() {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userRole != "admin") {
      return const Scaffold(
        body: Center(child: Text("Access Denied!", style: TextStyle(fontSize: 18, color: Colors.red))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: const Center(child: Text("Welcome, Admin!", style: TextStyle(fontSize: 20))),
    );
  }
}
