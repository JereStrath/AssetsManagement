import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class ImportAssetsPage extends StatefulWidget {
  const ImportAssetsPage({super.key});

  @override
  State<ImportAssetsPage> createState() => _ImportAssetsPageState();
}

class _ImportAssetsPageState extends State<ImportAssetsPage> {
  String? _selectedFilePath;
  String _importStatus = '';
  bool _isImporting = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any, // You can specify the file type if needed (e.g., FileType.CSV)
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFilePath = result.files.first.path;
        _importStatus = ''; // Reset import status on new file selection
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected file: ${path.basename(_selectedFilePath!)}')),
      );
    } else {
      // User canceled the picker
    }
  }

  Future<void> _importAssets() async {
    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file to import.')),
      );
      return;
    }

    setState(() {
      _isImporting = true;
      _importStatus = 'Importing...';
    });

    try {
      // Simulate import process (replace with your actual import logic)
      await Future.delayed(const Duration(seconds: 3));

      // For demonstration purposes, let's just read the file path
      File importedFile = File(_selectedFilePath!);
      if (await importedFile.exists()) {
        setState(() {
          _importStatus = 'Import successful!';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assets imported successfully.')),
        );
      } else {
        setState(() {
          _importStatus = 'Error: Could not read the selected file.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Could not read the selected file.')),
        );
      }
    } catch (e) {
      setState(() {
        _importStatus = 'Import failed: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import failed: $e')),
      );
    } finally {
      setState(() {
        _isImporting = false;
      });
    }
  }

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
                      onPressed: _isImporting ? null : _pickFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF273654),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Select File',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedFilePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        'Selected File: ${path.basename(_selectedFilePath!)}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isImporting ? null : _importAssets,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF273654),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isImporting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
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
                  if (_importStatus.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _importStatus,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _importStatus.startsWith('Error') ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
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