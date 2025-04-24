import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ensure this file exists
import 'screens/auth_gate.dart';
import 'screens/auth/login_screen.dart'; // Ensure this exists
import 'screens/home_screen.dart'; // Ensure this exists
import 'screens/auth/signup_screen.dart'; // Ensure this exists 
import 'screens/admin_dashboard.dart'; // Ensure this exists
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/customer_drawer.dart'; // Ensure this exists
import 'screens/admin_drawer.dart'; // Ensure this exists

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asset Management App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => FutureBuilder<String?>(
              future: _getUserRole(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.data != "admin") {
                  return const Scaffold(
                    body: Center(child: Text("Access Denied!", style: TextStyle(fontSize: 18, color: Colors.red))),
                  );
                }
                return const AdminDashboard();
              },
            ),
      },
    );
  }

  Future<String?> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.exists ? userDoc['role'] : null;
    }
    return null;
  }
}