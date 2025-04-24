import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
          ListTile(
            title: const Text("Assets"),
            onTap: () {
              Navigator.pushNamed(context, '/assets');
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
