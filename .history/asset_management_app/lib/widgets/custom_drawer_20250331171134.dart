import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? userRole;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      setState(() {
        userRole = userDoc['role'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text("Menu", style: TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    title: const Text("Home"),
                    onTap: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  if (userRole == "admin") // Show only for Admins
                    ListTile(
                      title: const Text("Admin Panel"),
                      onTap: () {
                        Navigator.pushNamed(context, '/admin');
                      },
                    ),
                  ListTile(
                    title: const Text("Logout"),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
    );
  }
}
