import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_real_time_data/home_page.dart';
import 'package:firebase_real_time_data/firebase_services.dart';
import 'package:firebase_real_time_data/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create Account!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 44),
                TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _nameTEController,
                    decoration: const InputDecoration(hintText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    }),
                const SizedBox(height: 24),
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
                const SizedBox(height: 44),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                      onPressed: _onSignup, child: const Text('SIGN UP')),
                const SizedBox(height: 44),
                RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                        text: 'Have account? ',
                        children: [
                      TextSpan(
                          style: const TextStyle(color: Colors.blue),
                          text: 'Login',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (_) => false);
                            })
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignup() async {
    if (_globalKey.currentState!.validate()) {
      _isLoading = true;
      setState(() {});
      User? user = await AuthServices.onSignup(
          _emailTEController.text.trim(), _passwordTEController.text);
      if (user != null) {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (_) => false);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Something Went Wrong')));
        }
      }
    }
    _isLoading = false;
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Empty text field')));
    }
  }
}
