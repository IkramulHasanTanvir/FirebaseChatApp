import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class OTPService {
  // Generate a 6-digit OTP
  static String _generateOTP() {
    return (100000 + Random().nextInt(900000)).toString(); // 6-digit OTP
  }

  // Send OTP to Firestore for the provided email
  static Future<void> sendOTP(String email) async {
    String otp = _generateOTP();

    try {
      await FirebaseFirestore.instance.collection('email_otp').doc(email).set({
        'otp': otp,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('OTP for $email: $otp'); // For debugging, you can remove this in production
    } catch (e) {
      print('Error sending OTP: $e');  // Log error if sending OTP fails
    }
  }
}
