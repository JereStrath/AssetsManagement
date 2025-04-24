import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(String userId, String name, String email, String role) async {
    await _db.collection('users').doc(userId).set({
      'userId': userId,
      'name': name,
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getAssets() {
    return _db.collection('assets').snapshots();
  }

  Future<void> addAsset(String assetId, String name, String category) async {
    await _db.collection('assets').doc(assetId).set({
      'assetId': assetId,
      'name': name,
      'category': category,
      'status': 'Available',
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
}
