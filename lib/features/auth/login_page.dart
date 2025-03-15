import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/widgets/custom_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

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
      await AuthServices.onLogin(
          _emailController.text.trim(), _passwordController.text.trim());
      if (mounted) customNavigatorPushRemoveAll(context, const ChatsPage());
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
