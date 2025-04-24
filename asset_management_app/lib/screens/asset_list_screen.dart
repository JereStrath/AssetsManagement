import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckAssetsScreen extends StatelessWidget {
  const CheckAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color navyBlue = const Color(0xFF1B2B48);
    final TextStyle buttonTextStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    "Check Assets",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: navyBlue,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar and Scan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    "SEARCH",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search...",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: navyBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navyBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("SCAN"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Asset Table Header
            Container(
              color: navyBlue,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: const [
                  Expanded(child: _TableHeader(title: "ASSET\nNUMBER:")),
                  Expanded(child: _TableHeader(title: "ITEM NAME:")),
                  Expanded(child: _TableHeader(title: "SERIAL\nNUMBER:")),
                  Expanded(child: _TableHeader(title: "ITEM\nDESCRIPTION:")),
                  Expanded(child: _TableHeader(title: "CATEGORY")),
                  Expanded(child: _TableHeader(title: "MODEL")),
                ],
              ),
            ),

            // Table Body from Firestore
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('assets')
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No assets found."));
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final asset =
                            docs[index].data() as Map<String, dynamic>;

                        return Row(
                          children: [
                            Expanded(
                              child: _TableCell(
                                text: asset['assetNumber'] ?? '',
                              ),
                            ),
                            Expanded(
                              child: _TableCell(text: asset['itemName'] ?? ''),
                            ),
                            Expanded(
                              child: _TableCell(
                                text: asset['serialNumber'] ?? '',
                              ),
                            ),
                            Expanded(
                              child: _TableCell(
                                text: asset['itemDescription'] ?? '',
                              ),
                            ),
                            Expanded(
                              child: _TableCell(text: asset['category'] ?? ''),
                            ),
                            Expanded(
                              child: _TableCell(text: asset['model'] ?? ''),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _RoundedButton(text: "ADD NEW", color: navyBlue),
                      _RoundedButton(text: "EDIT", color: navyBlue),
                      _RoundedButton(text: "DELETE", color: navyBlue),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navyBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "DELETE ALL",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
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

class _TableHeader extends StatelessWidget {
  final String title;
  const _TableHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1B2B48), width: 0.3),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class _RoundedButton extends StatelessWidget {
  final String text;
  final Color color;

  const _RoundedButton({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
