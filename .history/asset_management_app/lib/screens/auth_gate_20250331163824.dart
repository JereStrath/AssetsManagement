import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/admin_dashboard.dart';
import '../screens/home_screen.dart';
import '../screens/auth/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserRole(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists ? userDoc['role'] : null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return FutureBuilder<String?>(
            future: _getUserRole(snapshot.data!.uid),
            builder: (context, roleSnapshot) {
              if (!roleSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (roleSnapshot.data == "admin") {
                return const AdminDashboard();
              } else {
                return const  ();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
