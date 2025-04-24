import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../screens/add_asset_screen.dart';

class CheckAssetsScreen extends StatefulWidget {
  const CheckAssetsScreen({super.key});

  @override
  State<CheckAssetsScreen> createState() => _CheckAssetsScreenState();
}

class _CheckAssetsScreenState extends State<CheckAssetsScreen> {
  static const Color navyBlue = Color(0xFF1B2B48);
  static const Color primaryBlue = Color(0xFF1B2B48);
  static const Color white = Colors.white;
  final Set<String> _selectedAssetIds = {};
  String searchQuery = '';
  String sortBy = 'assetNumber';
  bool ascending = true;
  bool _selectAll = false;

  void _navigateToAddAssetScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAssetPage()),
    );
  }

  Future<void> _editAssetDialog(DocumentSnapshot doc) async {
    final data = doc.data()! as Map<String, dynamic>;
    final controllers = <String, TextEditingController>{
      'assetNumber': TextEditingController(text: data['assetNumber']?.toString()),
      'itemName': TextEditingController(text: data['itemName']?.toString()),
      'serialNumber': TextEditingController(text: data['serialNumber']?.toString()),
      'itemDescription':
          TextEditingController(text: data['itemDescription']?.toString()),
      'category': TextEditingController(text: data['category']?.toString()),
      'modelBrand': TextEditingController(text: data['model']?.toString()),
      'warrantyInformation':
          TextEditingController(text: data['warrantyInformation']?.toString()),
      'assignedTo': TextEditingController(text: data['assignedTo']?.toString()),
      'site': TextEditingController(text: data['site']?.toString()),
      'location': TextEditingController(text: data['location']?.toString()),
      'subLocation': TextEditingController(text: data['subLocation']?.toString()),
      'department': TextEditingController(text: data['department']?.toString()),
      'floor': TextEditingController(text: data['floor']?.toString()),
      'room': TextEditingController(text: data['room']?.toString()),
      'status': TextEditingController(text: data['status']?.toString()),
    };

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Asset"),
        content: SingleChildScrollView(
          child: Column(
            children: controllers.entries.map((entry) {
              return TextField(
                controller: entry.value,
                decoration: InputDecoration(
                  labelText: _humanizeFieldName(entry.key),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedData = controllers.map(
                (key, controller) => MapEntry(key, controller.text),
              );
              await FirebaseFirestore.instance
                  .collection('assets')
                  .doc(doc.id)
                  .update(updatedData);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAssets(List<String> docIds) async {
    if (docIds.isEmpty) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Assets"),
        content: Text(
          "Are you sure you want to delete ${_selectedAssetIds.length} asset(s)? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final batch = FirebaseFirestore.instance.batch();
              for (final id in docIds) {
                batch.delete(FirebaseFirestore.instance.collection('assets').doc(id));
              }
              await batch.commit();
              setState(() {
                _selectedAssetIds.clear();
                _selectAll = false;
              });
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAllAssets() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete All Assets"),
        content: const Text(
          "Are you sure you want to delete all assets? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final snapshot =
                  await FirebaseFirestore.instance.collection('assets').get();
              final batch = FirebaseFirestore.instance.batch();
              for (final doc in snapshot.docs) {
                batch.delete(doc.reference);
              }
              await batch.commit();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _toggleSort(String column) {
    setState(() {
      if (sortBy == column) {
        ascending = !ascending;
      } else {
        sortBy = column;
        ascending = true;
      }
    });
  }

  List<QueryDocumentSnapshot> _applyFiltersAndSorting(
    List<QueryDocumentSnapshot> docs,
  ) {
    final query = searchQuery.toLowerCase();
    final filtered = docs.where((doc) {
      final data = doc.data()! as Map<String, dynamic>;
      return (data['assetNumber']?.toString().toLowerCase().contains(query) ??
              false) ||
          (data['itemName']?.toString().toLowerCase().contains(query) ?? false) ||
          (data['serialNumber']?.toString().toLowerCase().contains(query) ??
              false);
    }).toList();

    filtered.sort((a, b) {
      final aData = (a.data()! as Map<String, dynamic>)[sortBy]?.toString() ?? '';
      final bData = (b.data()! as Map<String, dynamic>)[sortBy]?.toString() ?? '';
      return ascending ? aData.compareTo(bData) : bData.compareTo(aData);
    });

    return filtered;
  }

  Future<void> _startScan() async {
    final scannedValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScanner()),
    );

    if (scannedValue != null) {
      setState(() => searchQuery = scannedValue);
    }
  }

  void _toggleSelect(String assetId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedAssetIds.add(assetId);
      } else {
        _selectedAssetIds.remove(assetId);
      }
    });
  }

  void _toggleSelectAll(List<QueryDocumentSnapshot> assets) {
    setState(() {
      if (_selectAll) {
        _selectedAssetIds.clear();
      } else {
        _selectedAssetIds.addAll(assets.map((doc) => doc.id));
      }
      _selectAll = !_selectAll;
    });
  }

  String _humanizeFieldName(String fieldName) {
    return fieldName.replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1 $2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF192A56),
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Check Assets",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "SEARCH",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(text: searchQuery),
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: "Search...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navyBlue,
                      foregroundColor: white,
                    ),
                    onPressed: _startScan,
                    child: const Text("SCAN"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('assets')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No assets found."));
                      }

                      final docs = _applyFiltersAndSorting(snapshot.data!.docs);

                      return DataTable(
                        showCheckboxColumn: false, // ADDED THIS LINE
                        columns: [
                          DataColumn(
                            label: Checkbox(
                              value: _selectAll,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  _toggleSelectAll(docs);
                                }
                              },
                            ),
                          ),
                          DataColumn(
                              label: _HeaderSort(
                            title: 'Asset Number',
                            sortKey: 'assetNumber',
                            onTap: _toggleSort,
                            currentSort: sortBy,
                            ascending: ascending,
                          )),
                          DataColumn(
                              label: _HeaderSort(
                            title: 'Item Name',
                            sortKey: 'itemName',
                            onTap: _toggleSort,
                            currentSort: sortBy,
                            ascending: ascending,
                          )),
                          DataColumn(
                              label: _HeaderSort(
                            title: 'Serial Number',
                            sortKey: 'serialNumber',
                            onTap: _toggleSort,
                            currentSort: sortBy,
                            ascending: ascending,
                          )),
                          const DataColumn(label: Text('Description')),
                          const DataColumn(label: Text('Category')),
                          const DataColumn(label: Text('Model')),
                          const DataColumn(label: Text('Warranty')),
                          const DataColumn(label: Text('Assigned To')),
                          const DataColumn(label: Text('Site')),
                          const DataColumn(label: Text('Location')),
                          const DataColumn(label: Text('Sub Location')),
                          const DataColumn(label: Text('Department')),
                          const DataColumn(label: Text('Floor')),
                          const DataColumn(label: Text('Room')),
                          const DataColumn(label: Text('Status')),
                        ],
                        rows: docs.map<DataRow>((doc) {
                          final data = doc.data()! as Map<String, dynamic>;
                          final isSelected = _selectedAssetIds.contains(doc.id);
                          return DataRow(
                            selected: isSelected,
                            onSelectChanged: (bool? selected) {
                              if (selected != null) {
                                _toggleSelect(doc.id, selected);
                                if (!selected && _selectAll) {
                                  setState(() => _selectAll = false);
                                } else if (_selectedAssetIds.length ==
                                        docs.length &&
                                    !_selectAll) {
                                  setState(() => _selectAll = true);
                                }
                              }
                            },
                            cells: [
                              DataCell(
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      _toggleSelect(doc.id, value);
                                      if (!value && _selectAll) {
                                        setState(() => _selectAll = false);
                                      } else if (_selectedAssetIds.length ==
                                              docs.length &&
                                          !_selectAll) {
                                        setState(() => _selectAll = true);
                                      }
                                    }
                                  },
                                ),
                              ),
                              DataCell(Text(data['assetNumber']?.toString() ?? '')),
                              DataCell(Text(data['itemName']?.toString() ?? '')),
                              DataCell(
                                  Text(data['serialNumber']?.toString() ?? '')),
                              DataCell(
                                  Text(data['itemDescription']?.toString() ?? '')),
                              DataCell(Text(data['category']?.toString() ?? '')),
                              DataCell(Text(data['modelBrand']?.toString() ?? '')),
                              DataCell(Text(
                                  data['warrantyInformation']?.toString() ?? '')),
                              DataCell(Text(data['assignedTo']?.toString() ?? '')),
                              DataCell(Text(data['site']?.toString() ?? '')),
                              DataCell(Text(data['location']?.toString() ?? '')),
                              DataCell(
                                  Text(data['subLocation']?.toString() ?? '')),
                              DataCell(Text(data['department']?.toString() ?? '')),
                              DataCell(Text(data['floor']?.toString() ?? '')),
                              DataCell(Text(data['room']?.toString() ?? '')),
                              DataCell(Text(data['status']?.toString() ?? '')),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Asset'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: white,
                          ),
                          onPressed: _navigateToAddAssetScreen,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: white,
                          ),
                          onPressed: _selectedAssetIds.length == 1
                              ? () async {
                                  final doc = await FirebaseFirestore.instance
                                      .collection('assets')
                                      .doc(_selectedAssetIds.first)
                                      .get();
                                  if (doc.exists) {
                                    _editAssetDialog(doc);
                                  }
                                }
                              : null,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: white,
                          ),
                          onPressed: _selectedAssetIds.isNotEmpty
                              ? () => _deleteAssets(_selectedAssetIds.toList())
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('Delete All'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: white,
                          ),
                          onPressed: _deleteAllAssets,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSort extends StatelessWidget {
  const _HeaderSort({
    required this.title,
    required this.sortKey,
    required this.onTap,
    required this.currentSort,
    required this.ascending,
  });
  final String title;
  final String sortKey;
  final Function(String) onTap;
  final String currentSort;
  final bool ascending;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(sortKey),
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center),
          if (sortKey == currentSort)
            Icon(ascending ? Icons.arrow_upward : Icons.arrow_downward),
        ],
      ),
    );
  }
}

class BarcodeScanner extends StatelessWidget {
  const BarcodeScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        onDetect: (barcodeCapture) {
          final barcode = barcodeCapture.barcodes.first;
          if (barcode.rawValue != null) {
            Navigator.pop(context, barcode.rawValue);
          }
        },
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
