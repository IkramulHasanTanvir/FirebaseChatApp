import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/features/auth/signup_page.dart';
import 'package:firebase_real_time_data/features/ui/forgot_pass_page.dart';
import 'package:firebase_real_time_data/features/ui/home_page.dart';
import 'package:firebase_real_time_data/firebase_services/firebase_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: background),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 44),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      }),
                  const SizedBox(height: 24),
                  TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          customNavigator(context, const ForgotPassPage());

                        },
                        child: const Text('Forgot Password'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                        onPressed: _onLogin, child: const Text('LOGIN')),
                  const SizedBox(height: 44),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                      text: 'Registrar? ',
                      children: [
                        TextSpan(
                          style: const TextStyle(color: Colors.blue),
                          text: 'Sign Up',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              customNavigator(context, const SignupPage());
                            },
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

  void _onLogin() async {
    if (_globalKey.currentState!.validate()) {
      _isLoading = true;
      setState(() {});
      User? user = await AuthServices.onLogin(
          _emailTEController.text.trim(), _passwordTEController.text);
      if (user != null) {
        if (mounted) {
          customNavigator(context, const HomePage());
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something Went Wrong')));
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Empty text field')));
      }
    }

    _isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
