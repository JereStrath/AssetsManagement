import 'package:flutter/material.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  _AddAssetPageState createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController siteController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController assignedUserController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customField1Controller = TextEditingController();


  String? selectedCategory;
  String? selectedStatus;
  double conditionRating = 3;

  final List<String> categories = ['Electronics', 'Furniture', 'Vehicles', 'Other'];
  final List<String> statuses = ['Active', 'In Maintenance', 'Retired', 'Damaged'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Asset"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Basic Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Asset Name")),
              TextField(controller: barcodeController, decoration: const InputDecoration(labelText: "Barcode/QR Code")),
              TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location")),
              TextField(controller: siteController, decoration: const InputDecoration(labelText: "Site")),
              
              TextField(controller: idController, decoration: const InputDecoration(labelText: "Asset Number")),
              TextField(controller: serialController, decoration: const InputDecoration(labelText: "Serial Number")),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
              
              const SizedBox(height: 10),
              const Text("Asset Category/Type"),
              DropdownButtonFormField(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() { selectedCategory = value; });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              
              const SizedBox(height: 10),
              const Text("Manufacturer & Model"),
              TextField(controller: manufacturerController, decoration: const InputDecoration(labelText: "Manufacturer")),
              TextField(controller: modelController, decoration: const InputDecoration(labelText: "Model")),
              
              const SizedBox(height: 10),
              const Text("Status"),
              Column(
                children: statuses.map((status) {
                  return RadioListTile(
                    title: Text(status),
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setState(() { selectedStatus = value; });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 10),
              const Text("Condition Assessment"),
              Slider(
                value: conditionRating,
                min: 1,
                max: 5,
                divisions: 4,
                label: conditionRating.toString(),
                onChanged: (value) {
                  setState(() { conditionRating = value; });
                },
              ),
              
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    child: const Text("Save"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text("Save and Add Another"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
