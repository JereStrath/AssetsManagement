import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController manufacturerController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController siteController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController assignedUserController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customField1Controller = TextEditingController();
  
  DateTime? warrantyDate;
  String? selectedCategory;
  String? selectedStatus = 'Active';
  double conditionRating = 3;
  String conditionLabel = 'Good';

  final List<String> categories = ['Electronics', 'Furniture', 'Vehicles', 'IT Equipment', 'Machinery', 'Other'];
  final List<String> statuses = ['Active', 'In Maintenance', 'Retired', 'Damaged'];
  
  Map<double, String> conditionLabels = {
    1: 'Poor',
    2: 'Fair',
    3: 'Good',
    4: 'Very Good',
    5: 'Excellent'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Asset"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionCard(
                  "Basic Information",
                  [
                    _buildTextField(nameController, "Asset Name", Icons.inventory, required: true),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(idController, "Asset ID", Icons.qr_code, required: true),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(serialController, "Serial Number", Icons.qr_code),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(barcodeController, "Barcode/QR Code", Icons.qr_code_scanner),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      value: selectedCategory,
                      items: categories,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      label: "Asset Category",
                      icon: Icons.category,
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(descriptionController, "Description", Icons.description, maxLines: 3),
                  ],
                ),
                
                _buildSectionCard(
                  "Manufacturer & Model",
                  [
                    _buildTextField(manufacturerController, "Manufacturer", Icons.business),
                    const SizedBox(height: 16),
                    _buildTextField(modelController, "Model", Icons.model_training),
                  ],
                ),
                
                _buildSectionCard(
                  "Location",
                  [
                    _buildTextField(siteController, "Site", Icons.location_on),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(departmentController, "Department", Icons.business_center),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(buildingController, "Building", Icons.apartment),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(roomController, "Room", Icons.meeting_room),
                  ],
                ),

                _buildSectionCard(
                  "Assignment & Warranty",
                  [
                    _buildTextField(assignedUserController, "Assigned To", Icons.person),
                    const SizedBox(height: 16),
                    _buildDatePicker(context),
                  ],
                ),
                
                _buildSectionCard(
                  "Additional Information",
                  [
                    _buildTextField(notesController, "Notes", Icons.note, maxLines: 3),
                    const SizedBox(height: 16),
                    _buildTextField(customField1Controller, "Custom Field", Icons.fact_check),
                  ],
                ),
                
                const SizedBox(height: 24),
                _buildButtonRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: "Enter $label",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String label,
    required IconData icon,
    bool required = false,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildChipSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Asset Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: statuses.map((status) {
            final isSelected = selectedStatus == status;
            Color chipColor;
            switch (status) {
              case 'Active':
                chipColor = Colors.green;
                break;
              case 'In Maintenance':
                chipColor = Colors.orange;
                break;
              case 'Retired':
                chipColor = Colors.grey;
                break;
              case 'Damaged':
                chipColor = Colors.red;
                break;
              default:
                chipColor = Theme.of(context).primaryColor;
                break;
            }
            
            return ChoiceChip(
              label: Text(
                status,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: chipColor,
              backgroundColor: Colors.grey.shade100,
              onSelected: (bool selected) {
                setState(() {
                  selectedStatus = selected ? status : selectedStatus;
                });
              },
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConditionSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Condition Assessment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                conditionLabels[conditionRating] ?? 'Good',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Theme.of(context).primaryColor,
            overlayColor: Theme.of(context).primaryColor.withOpacity(0.2),
            valueIndicatorColor: Theme.of(context).primaryColor,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: conditionRating,
            min: 1,
            max: 5,
            divisions: 4,
            label: conditionLabels[conditionRating],
            onChanged: (value) {
              setState(() {
                conditionRating = value;
                conditionLabel = conditionLabels[value] ?? 'Good';
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Poor', style: TextStyle(fontSize: 12)),
              Text('Fair', style: TextStyle(fontSize: 12)),
              Text('Good', style: TextStyle(fontSize: 12)),
              Text('Very Good', style: TextStyle(fontSize: 12)),
              Text('Excellent', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: warrantyDate ?? DateTime.now().add(const Duration(days: 365)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != warrantyDate) {
          setState(() {
            warrantyDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Warranty Expiry Date",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          prefixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        child: Text(
          warrantyDate == null ? "Select date" : DateFormat('MMMM dd, yyyy').format(warrantyDate!),
          style: TextStyle(
            color: warrantyDate == null ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save asset logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Asset saved successfully')),
                );
              }
            },
            icon: const Icon(Icons.save),
            label: const Text("Save"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Cancel"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save and add another logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Asset saved. Add another asset.')),
                );
                _formKey.currentState!.reset();
              }
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text("Save & Add More"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}