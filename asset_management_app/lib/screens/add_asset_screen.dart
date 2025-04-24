import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  _AddAssetPageState createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {
    'assetNumber': TextEditingController(),
    'itemName': TextEditingController(),
    'serialNumber': TextEditingController(),
    'itemDescription': TextEditingController(),
    'category': TextEditingController(),
    'modelBrand': TextEditingController(),
    'warrantyInformation': TextEditingController(),
    'assignedTo': TextEditingController(),
    'room': TextEditingController(),
    'status': TextEditingController(),
  };

  final Map<String, String?> selectedValues = {
    'site': null,
    'location': null,
    'subLocation': null,
    'department': null,
    'floor': null,
    'assignedTo': null,
    'room': null,
    'status': null,
  };

  final Map<String, List<String>> _dropdownOptions = {};
  final Map<String, String?> _cachedSelectedValues = {}; // New cache

  Future<void> _loadDropdownData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('dropdown_options').get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          _dropdownOptions['site'] =
              (data['sites'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          _dropdownOptions['location'] =
              (data['locations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          _dropdownOptions['subLocation'] =
              (data['sub_locations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          _dropdownOptions['department'] =
              (data['departments'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          _dropdownOptions['floor'] =
              (data['floors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          _dropdownOptions['assignedTo'] =
              (data['assigned_to'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          _dropdownOptions['room'] =
              (data['rooms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
          _dropdownOptions['status'] =
              (data['statuses'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

          // Load cached values after dropdown options are available
          _loadCachedSelectedValues();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not load dropdown options.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading dropdown options: $e')),
      );
    }
  }

  void _loadCachedSelectedValues() {
    setState(() {
      selectedValues.forEach((key, value) {
        if (_cachedSelectedValues.containsKey(key)) {
          selectedValues[key] = _cachedSelectedValues[key];
        }
      });
    });
  }

  Future<void> scanBarcode(TextEditingController controller) async {
    final scannedCode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerScreen()),
    );

    if (scannedCode != null && scannedCode.isNotEmpty) {
      setState(() {
        controller.text = scannedCode;
      });
    }
  }

  Future<void> saveAssetData() async {
    try {
      final assetData = {
        'assetNumber': controllers['assetNumber']!.text.trim(),
        'itemName': controllers['itemName']!.text.trim(),
        'serialNumber': controllers['serialNumber']!.text.trim(),
        'itemDescription': controllers['itemDescription']!.text.trim(),
        'category': controllers['category']!.text.trim(),
        'modelBrand': controllers['modelBrand']!.text.trim(),
        'warrantyInformation': controllers['warrantyInformation']!.text.trim(),
        ...selectedValues,
      };

      final dataToSave = assetData.map((key, value) {
        if (selectedValues.containsKey(key) && value == null) {
          return MapEntry(key, null);
        }
        return MapEntry(key, value);
      });

      await FirebaseFirestore.instance.collection('assets').add(dataToSave);

      // Cache the selected values upon successful save
      _cacheSelectedValues();

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

  void _cacheSelectedValues() {
    _cachedSelectedValues.clear();
    selectedValues.forEach((key, value) {
      if (value != null) {
        _cachedSelectedValues[key] = value;
      }
    });
  }

  void clearControllers() {
    for (var controller in controllers.values) {
      controller.clear();
    }
    setState(() {
      for (var key in selectedValues.keys) {
        selectedValues[key] = null;
      }
    });
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<void>(
        future: _loadDropdownData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Could not load dropdown options: ${snapshot.error}'));
          } else {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTextField(
                      controllers['assetNumber']!,
                      'ASSET NUMBER',
                      showScanButton: true,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(controllers['itemName']!, 'ITEM NAME'),
                    const SizedBox(height: 16),
                    buildTextField(
                      controllers['serialNumber']!,
                      'SERIAL NUMBER',
                      showScanButton: true,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(
                      controllers['itemDescription']!,
                      'ITEM DESCRIPTION',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    buildTextField(controllers['category']!, 'CATEGORY'),
                    const SizedBox(height: 16),
                    buildTextField(controllers['modelBrand']!, 'MODEL/BRAND'),
                    const SizedBox(height: 16),
                    buildTextField(
                      controllers['warrantyInformation']!,
                      'WARRANTY INFORMATION',
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField('assignedTo'),
                    const SizedBox(height: 16),
                    ...selectedValues.keys
                        .where((key) =>
                            key != 'assignedTo' && key != 'room' && key != 'status')
                        .map((key) => _buildDropdownField(key)),
                    _buildDropdownField('room'),
                    const SizedBox(height: 16),
                    _buildDropdownField('status'),
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
                            onPressed: () => _formKey.currentState?.reset(),
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
            );
          }
        },
      ),
    );
  }

  Widget _buildDropdownField(String fieldKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedValues[fieldKey],
          decoration: InputDecoration(
            labelText: fieldKey.toUpperCase(),
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          items: [
            ...(_dropdownOptions[fieldKey] ?? []).map(
              (value) => DropdownMenuItem(value: value, child: Text(value)),
            ),
            const DropdownMenuItem(value: 'add_new', child: Text('Add new...')),
          ],
          onChanged: (value) {
            if (value == 'add_new') {
              _showAddNewDialog(fieldKey);
            } else {
              setState(() {
                selectedValues[fieldKey] = value;
              });
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showAddNewDialog(String fieldKey) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add New ${fieldKey.toUpperCase()}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new value'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty &&
                  !(_dropdownOptions[fieldKey] ?? []).contains(newValue)) {
                setState(() {
                  _dropdownOptions[fieldKey] ??= [];
                  _dropdownOptions[fieldKey]!.add(newValue);
                  selectedValues[fieldKey] = newValue;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('ADD'),
          ),
        ],
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: showScanButton
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () => scanBarcode(controller),
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
}

class BarcodeScannerScreen extends StatelessWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final String code = barcode.rawValue ?? '---';
          Navigator.pop(context, code);
        },
      ),
    );
  }
}