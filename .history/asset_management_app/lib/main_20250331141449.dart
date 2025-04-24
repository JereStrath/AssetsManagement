import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Assets')),
        body: StreamBuilder(
          stream: _db.collection('assets').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            var assets = snapshot.data!.docs;
            return ListView.builder(
              itemCount: assets.length,
              itemBuilder: (context, index) {
                var asset = assets[index];
                return ListTile(
                  title: Text(asset['name']),
                  subtitle: Text(asset['category']),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _db.collection('assets').add({
              'name': 'New Asset',
              'category': 'Electronics',
              'status': 'Available',
              'lastUpdated': FieldValue.serverTimestamp(),
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
