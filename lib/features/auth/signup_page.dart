import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../common/custom_navigator.dart';
import '../../firebase_services/firebase_services.dart';
import 'login_page.dart';
import '../ui/chats_page.dart';

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
                      validator: RequiredValidator(errorText: 'Enter your name')),
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
                          onPressed: _onSignup, child: const Text('SIGN UP')),
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
                            ..onTap =
                                () => customNavigator(context, const LoginPage()),
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

  Future<void> _onSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await AuthServices.onSignup(
          _emailController.text.trim(), _passwordController.text.trim());
      if (mounted) customNavigator(context, const ChatsPage());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
