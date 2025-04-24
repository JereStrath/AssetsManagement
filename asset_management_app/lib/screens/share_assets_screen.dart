import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ShareAssetsScreen extends StatefulWidget {
  const ShareAssetsScreen({super.key});

  @override
  State<ShareAssetsScreen> createState() => _ShareAssetsScreenState();
}

class _ShareAssetsScreenState extends State<ShareAssetsScreen> {
  bool _isExporting = false;
  String _exportStatus = '';

  Future<void> _exportAssetsToCSV() async {
    setState(() {
      _isExporting = true;
      _exportStatus = 'Exporting assets...';
    });

    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('assets').get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _isExporting = false;
          _exportStatus = 'No assets to export.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No assets to export.')),
        );
        return;
      }

      // Extract data for CSV
      List<List<dynamic>> assetData = [
        <String>[
          'Asset Number',
          'Item Name',
          'Serial Number',
          'Description',
          'Category',
          'Model',
          'Warranty',
          'Assigned To',
          'Site',
          'Location',
          'Sub Location',
          'Department',
          'Floor',
          'Room',
          'Status',
        ],
        ...snapshot.docs.map((doc) {
          final data = doc.data();
          return [
            data['assetNumber'] ?? '',
            data['itemName'] ?? '',
            data['serialNumber'] ?? '',
            data['itemDescription'] ?? '',
            data['category'] ?? '',
            data['model'] ?? '',
            data['warrantyInformation'] ?? '',
            data['assignedTo'] ?? '',
            data['site'] ?? '',
            data['location'] ?? '',
            data['subLocation'] ?? '',
            data['department'] ?? '',
            data['floor'] ?? '',
            data['room'] ?? '',
            data['status'] ?? '',
          ];
        }),
      ];

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(assetData);

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/assets.csv';
      final File file = File(path);

      // Write CSV to file
      await file.writeAsString(csv);

      // Share the file
      await Share.shareXFiles([XFile(path)], text: 'Here are your assets in CSV format.');

      setState(() {
        _isExporting = false;
        _exportStatus = 'Assets exported and shared successfully.';
      });
    } catch (e) {
      setState(() {
        _isExporting = false;
        _exportStatus = 'Error exporting assets: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting assets: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Column(
        children: [
          // Top patterned background with arrow and title
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/share.png', // Your share icon
                  height: 80,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Share Assets',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Curved white container below
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Would you like to share your assets? Click the button below to export them as a CSV file.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isExporting ? null : _exportAssetsToCSV,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25314C),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isExporting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Export as CSV',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_exportStatus.isNotEmpty)
                    Text(
                      _exportStatus,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _exportStatus.startsWith('Error')
                            ? Colors.red
                            : Colors.green,
                        fontWeight: FontWeight.bold,
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