import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_asset_screen.dart';
import 'asset_list_screen.dart';

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
        title: const Text("Asset Management", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('assets').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No assets available", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)));
            }
            var assets = snapshot.data!.docs;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: assets.length,
              itemBuilder: (context, index) {
                var asset = assets[index].data();
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    onTap: () {
                      // Navigate to Asset Details Screen (to be implemented)
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(asset['name'] ?? 'Unnamed Asset',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text("ID: ${assets[index].id}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
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
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_auth.currentUser?.displayName ?? "User"),
            accountEmail: Text(_auth.currentUser?.email ?? "user@example.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text("All Assets"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AssetListScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
