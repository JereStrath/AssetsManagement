import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerUser(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user role in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role, // Store role (admin/user)
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential.user;
    } catch (e) {
      print("Registration Error: $e");
      return null;
    }
  }
}
