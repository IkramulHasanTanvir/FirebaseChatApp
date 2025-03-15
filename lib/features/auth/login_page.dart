import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/widgets/custom_text_form_field.dart';
import 'package:firebase_real_time_data/features/ui/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/custom_navigator.dart';
import '../../firebase_services/firebase_services.dart';
import '../auth/signup_page.dart';
import '../ui/chats_page.dart';
import '../ui/forgot_pass_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController(text: 'tanvir@gmail.com');
  final _passwordController = TextEditingController(text: '123456');
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
                  const Text('Welcome Back!',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 40),
                  CustomTextFormField(
                      controller: _emailController,
                      hint: 'Email',
                      validator: EmailValidator(errorText: 'Enter a valid email'),
                  ),
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
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          customNavigatorPush(context, const ForgotPassPage()),
                      child: const Text('Forgot Password?',
                          style: TextStyle(color: Colors.amber)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _onLogin, child: const Text('LOGIN')),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(color: Colors.amber),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                customNavigatorPush(context, const SignupPage()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // Attempt login with email and password
      final loginResult = await AuthServices.onLogin(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Check if the login was successful
      if (loginResult != null) {
        // If login is successful, navigate to HomePage
        if (mounted) {
          customNavigatorPushRemoveAll(context, const HomePage());
        }
      } else {
        throw Exception('Account does not exist or incorrect credentials');
      }
    } catch (e) {
      // If login fails, show an error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
