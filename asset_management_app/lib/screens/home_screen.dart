import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_asset_screen.dart';
import 'asset_list_screen.dart';
import 'import_assets_screen.dart';
import 'share_assets_screen.dart';

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
      backgroundColor: const Color(0xFF0F0F0F),
      body: Stack(
        children: [
          // Optional patterned background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/background.png',
                ), // replace with your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      // Door image
                      Image.asset('assets/door.png', height: 150),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Reusable button builder
                      _buildMenuButton(
                        label: "Add Assets",
                        color: const Color(0xFF273654),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddAssetPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuButton(
                        label: "Check Assets",
                        color: Colors.indigo[800]!,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CheckAssetsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuButton(
                        label: "Import Assets",
                        color: const Color(0xFF273654),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ImportAssetsPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuButton(
                        label: "Share Assets",
                        color: Colors.indigo[800]!,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShareAssetsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuButton(
                        label: "Logout",
                        color: Colors.redAccent.shade700,
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
