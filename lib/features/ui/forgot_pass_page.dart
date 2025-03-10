import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/common/widgets/custom_text_form_field.dart';
import 'package:firebase_real_time_data/features/ui/otp_page.dart';
import 'package:firebase_real_time_data/firebase_services/otp_genarate.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final _emailTEController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (_emailTEController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await _auth.sendPasswordResetEmail(email: _emailTEController.text.trim());
      await OTPService.sendOTP(_emailTEController.text.trim()); // Send OTP

      if (mounted) {
        customNavigator(context, const OTPPage()); // Navigate to OTP page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent. Check your inbox.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: background),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 44),
              CustomTextFormField(
                controller: _emailTEController,
                hint: 'Email',
                validator: EmailValidator(errorText: 'Enter a valid email'),
              ),
              const SizedBox(height: 44),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('SEND CODE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
