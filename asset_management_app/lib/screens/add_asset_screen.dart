import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  _AddAssetPageState createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController assetNumberController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController itemDescriptionController =
      TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController modelBrandController = TextEditingController();
  final TextEditingController warrantyInformationController =
      TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController subLocationController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController floorController = TextEditingController();

  Future<void> saveAssetData() async {
    try {
      await FirebaseFirestore.instance.collection('assets').add({
        'assetNumber': assetNumberController.text.trim(),
        'itemName': itemNameController.text.trim(),
        'serialNumber': serialNumberController.text.trim(),
        'itemDescription': itemDescriptionController.text.trim(),
        'category': categoryController.text.trim(),
        'modelBrand': modelBrandController.text.trim(),
        'warrantyInformation': warrantyInformationController.text.trim(),
        'location': locationController.text.trim(),
        'subLocation': subLocationController.text.trim(),
        'department': departmentController.text.trim(),
        'floor': floorController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asset data saved successfully')),
      );

      _formKey.currentState?.reset();
      clearControllers();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving data: $e')));
    }
  }

  void clearControllers() {
    assetNumberController.clear();
    itemNameController.clear();
    serialNumberController.clear();
    itemDescriptionController.clear();
    categoryController.clear();
    modelBrandController.clear();
    warrantyInformationController.clear();
    locationController.clear();
    subLocationController.clear();
    departmentController.clear();
    floorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collect Assets",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF192A56),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                assetNumberController,
                'ASSET NUMBER',
                showScanButton: true,
              ),
              const SizedBox(height: 16),
              buildTextField(itemNameController, 'ITEM NAME'),
              const SizedBox(height: 16),
              buildTextField(
                serialNumberController,
                'SERIAL NUMBER',
                showScanButton: true,
              ),
              const SizedBox(height: 16),
              buildTextField(
                itemDescriptionController,
                'ITEM DESCRIPTION',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              buildTextField(categoryController, 'CATEGORY'),
              const SizedBox(height: 16),
              buildTextField(modelBrandController, 'MODEL/BRAND'),
              const SizedBox(height: 16),
              buildTextField(
                warrantyInformationController,
                'WARRANTY INFORMATION',
              ),
              const SizedBox(height: 16),
              _buildLocationRow(locationController, 'LOCATION'),
              const SizedBox(height: 16),
              _buildLocationRow(subLocationController, 'SUB LOCATION'),
              const SizedBox(height: 16),
              _buildLocationRow(departmentController, 'DEPARTMENT'),
              const SizedBox(height: 16),
              _buildLocationRow(floorController, 'FLOOR'),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveAssetData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF192A56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _formKey.currentState?.reset();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF192A56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'CLEAR',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: clearControllers,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF192A56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'CLEAR ALL',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool showScanButton = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon:
            showScanButton
                ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement scan functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF192A56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(80, 40),
                    ),
                    child: const Text(
                      'SCAN',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
                : null,
      ),
    );
  }

  Widget _buildLocationRow(TextEditingController controller, String label) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            // Optional: Implement add location logic
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
          ),
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            controller.clear();
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
          ),
          child: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
