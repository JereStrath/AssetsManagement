import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up with Email & Password
  Future<User?> signUp(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store user role in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role, // "admin" or "user"
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // Login with Email & Password
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      User? user = userCredential.user;

      // Check if user already exists in Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();

      if (!userDoc.exists) {
        // Assign default role if new user
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'role': 'user', // Default to "user"
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Get User Role
  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return userDoc.exists ? userDoc['role'] : null;
    }
    return null;
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  // Get Current User
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
