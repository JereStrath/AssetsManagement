import 'package:flutter/material.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  _AddAssetPageState createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController assignedUserController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? warrantyDate;
  String? selectedCategory;
  String? selectedStatus = 'Active';
  double conditionRating = 3;

  List<String> categories = [
    'Electronics',
    'Furniture',
    'Vehicles',
    'IT Equipment',
    'Machinery',
    'Other',
  ];
  List<String> statuses = ['Active', 'In Maintenance', 'Retired', 'Damaged'];
  Map<double, String> conditionLabels = {
    1: 'Poor',
    2: 'Fair',
    3: 'Good',
    4: 'Very Good',
    5: 'Excellent',
  };

  List<String> manufacturers = ['Apple', 'Dell', 'HP', 'Samsung'];
  List<String> models = ['Model X', 'Model Y', 'Model Z'];
  List<String> sites = ['Head Office', 'Branch A', 'Branch B'];
  List<String> departments = ['IT', 'HR', 'Finance'];
  List<String> buildings = ['Building A', 'Building B', 'Building C'];
  List<String> rooms = ['Room 101', 'Room 102', 'Room 103'];

  String? selectedManufacturer;
  String? selectedModel;
  String? selectedSite;
  String? selectedDepartment;
  String? selectedBuilding;
  String? selectedRoom;

  void _addNewItem(
    String title,
    List<String> list,
    Function(String) onSelected,
  ) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new $title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    list.add(controller.text);
                    onSelected(controller.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Asset"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                'Manufacturer',
                manufacturers,
                selectedManufacturer,
                (value) => setState(() => selectedManufacturer = value),
              ),
              _buildDropdown(
                'Model',
                models,
                selectedModel,
                (value) => setState(() => selectedModel = value),
              ),
              _buildDropdown(
                'Site',
                sites,
                selectedSite,
                (value) => setState(() => selectedSite = value),
              ),
              _buildDropdown(
                'Department',
                departments,
                selectedDepartment,
                (value) => setState(() => selectedDepartment = value),
              ),
              _buildDropdown(
                'Building',
                buildings,
                selectedBuilding,
                (value) => setState(() => selectedBuilding = value),
              ),
              _buildDropdown(
                'Room',
                rooms,
                selectedRoom,
                (value) => setState(() => selectedRoom = value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Asset saved successfully')),
                    );
                  }
                },
                child: const Text('Save Asset'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selectedItem,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedItem,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                items:
                    items.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: onChanged,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
              onPressed:
                  () => _addNewItem(label, items, (value) => onChanged(value)),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
