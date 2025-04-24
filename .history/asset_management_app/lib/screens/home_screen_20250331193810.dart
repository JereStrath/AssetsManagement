import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_asset_screen.dart'; // Ensure this screen exists
import 'asset_list_screen.dart'; // Ensure this screen exists

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asset Management"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('assets').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No assets available"));
          }
          var assets = snapshot.data!.docs;
          return ListView.builder(
            itemCount: assets.length,
            itemBuilder: (context, index) {
              var asset = assets[index].data();
              return ListTile(
                title: Text(asset['name'] ?? 'Unnamed Asset'),
                subtitle: Text("ID: ${assets[index].id}"),
                onTap: () {
                  // Navigate to Asset Details Screen (to be implemented)
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAssetPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer() {
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
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pushNamed(context, '/settings'); // Settings screen (to be created)
            },
          ),
          ListTile(
            title: const Text("Logout"),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}