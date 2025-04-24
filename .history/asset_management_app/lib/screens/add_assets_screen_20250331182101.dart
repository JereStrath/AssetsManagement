import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  _AddAssetPageState createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();

  Future<void> _scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', "Cancel", true, ScanMode.BARCODE,
    );
    if (barcode != '-1') {
      setState(() {
        _barcodeController.text = barcode;
      });
    }
  }

  Future<void> _saveAsset() async {
    if (_nameController.text.isEmpty || _categoryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('assets').add({
      'name': _nameController.text,
      'category': _categoryController.text,
      'barcode': _barcodeController.text,
      'purchase_date': _purchaseDateController.text,
      'status': 'Active',
      'created_at': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Asset")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Asset Name")),
            TextField(controller: _categoryController, decoration: const InputDecoration(labelText: "Category")),
            TextField(controller: _barcodeController, decoration: const InputDecoration(labelText: "Barcode/QR Code")),
            ElevatedButton(onPressed: _scanBarcode, child: const Text("Scan Barcode")),
            TextField(
              controller: _purchaseDateController,
              decoration: const InputDecoration(labelText: "Purchase Date"),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveAsset, child: const Text("Save Asset")),
          ],
        ),
      ),
    );
  }
}
