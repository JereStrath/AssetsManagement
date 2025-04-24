import 'package:flutter/material.dart';

class ImportAssetsPage extends StatelessWidget {
  const ImportAssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Column(
        children: [
          // Top background with pattern and icon
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.import_export, size: 60, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'Import Assets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Bottom curved white container
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Imported assets will be from your device. Ensure that they are locally stored in your device',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1A2B4C),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle file picker or import logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF273654),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Import',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
