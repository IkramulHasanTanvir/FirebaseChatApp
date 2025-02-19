import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Returns the currently signed-in user.
  static User? get currentUser => _firebaseAuth.currentUser;

  /// Sign up with email and password.
  static Future<User?> onSignup(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Send email verification
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      return user;
    } on FirebaseAuthException catch (e) {
      return Future.error(_handleAuthError(e));
    } catch (e) {
      return Future.error("Something went wrong: ${e.toString()}");
    }
  }

  /// Log in with email and password.
  static Future<User?> onLogin(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      return Future.error(_handleAuthError(e));
    } catch (e) {
      return Future.error("Something went wrong: ${e.toString()}");
    }
  }

  /// Log out the current user.
  static Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  /// Handles Firebase authentication errors.
  static String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
