import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/widgets/custom_text_form_field.dart';
import 'package:firebase_real_time_data/features/ui/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../common/custom_navigator.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: background,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Create Account!',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 40),
                  CustomTextFormField(
                      controller: _nameController,
                      hint: 'Name',
                      validator:
                          RequiredValidator(errorText: 'Enter your name')),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                      controller: _emailController,
                      hint: 'Email',
                      validator:
                          EmailValidator(errorText: 'Enter a valid email')),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _passwordController,
                    hint: 'Password',
                    validator: LengthRangeValidator(
                        min: 6,
                        max: 12,
                        errorText: 'Password must be 6-12 characters'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: nextPage,
                    child: const Text('SIGN UP'),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                      text: 'Have an account? ',
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: const TextStyle(color: Colors.amber),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => customNavigatorPushRemoveAll(
                                context, const LoginPage()),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void nextPage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true); // 👈 Start loading

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      customNavigatorPushRemoveAll(
        context,
        const HomePage(),
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError("An error occurred. Please try again.");
    }

    setState(() => _isLoading = false); // 👈 Stop loading
  }

  void _showError(String? message) {
    setState(() => _isLoading = false); // 👈 Stop loading on error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? "An error occurred")),
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
