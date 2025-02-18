import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  static Future<User?> onSignup(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<User?> onLogin(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
