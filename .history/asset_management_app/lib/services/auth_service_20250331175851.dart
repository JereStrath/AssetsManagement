import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up with Email & Password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'createdAt': DateTime.now(),
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
      if (googleUser == null) return null; // User canceled login

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Store user in Firestore if not already added
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'name': user.displayName,
            'photoUrl': user.photoURL,
            'createdAt': DateTime.now(),
          });
        }
      }
      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
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
