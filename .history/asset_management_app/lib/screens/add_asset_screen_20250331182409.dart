import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAssetPage extends StatefulWidget {
  const AddAssetPage({super.key});

  @override
  _AddAssetPageState createState() => _AddAssetPageState();
}

class _AddAssetPageState extends State<AddAssetPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController newCategoryController = TextEditingController();
  String? selectedCategory;
  bool addingNewCategory = false;

  @override
  void dispose() {
    nameController.dispose();
    newCategoryController.dispose();
    super.dispose();
  }

  Future<List<String>> _fetchCategories() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').get();
    return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
  }

  Future<void> _addNewCategory() async {
    if (newCategoryController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('categories').add({'name': newCategoryController.text});
      setState(() {
        selectedCategory = newCategoryController.text;
        addingNewCategory = false;
      });
      newCategoryController.clear();
    }
  }

  Future<void> _saveAsset() async {
    if (nameController.text.isNotEmpty && selectedCategory != null) {
      await FirebaseFirestore.instance.collection('assets').add({
        'name': nameController.text,
        'category': selectedCategory,
        'createdAt': Timestamp.now(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Asset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Asset Name'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<String>>(
              future: _fetchCategories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                List<String> categories = snapshot.data!;
                return DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: [
                    ...categories.map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ),
                    ),
                    const DropdownMenuItem(
                      value: 'add_new',
                      child: Text('+ Add New Category'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == 'add_new') {
                      setState(() => addingNewCategory = true);
                    } else {
                      setState(() => selectedCategory = value);
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                );
              },
            ),
            if (addingNewCategory) ...[
              TextField(
                controller: newCategoryController,
                decoration: const InputDecoration(labelText: 'New Category'),
              ),
              ElevatedButton(
                onPressed: _addNewCategory,
                child: const Text('Save Category'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAsset,
              child: const Text('Save Asset'),
            ),
          ],
        ),
      ),
    );
  }
}