import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/features/auth/login_page.dart';
import 'package:firebase_real_time_data/features/ui/chats_page.dart';
import 'package:firebase_real_time_data/firebase_services/firebase_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

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
      body: Container(
        decoration: BoxDecoration(
          gradient: background
        ),
        child: SafeArea(
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      keyboardType: TextInputType.text,
                      controller: _nameTEController,
                      decoration: const InputDecoration(hintText: 'Name'),
                      validator: RequiredValidator(errorText: 'Enter your name').call,
                  const SizedBox(height: 24),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTEController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: EmailValidator(errorText: 'Enter your valid Email').call),
                  const SizedBox(height: 24),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'password'),
                      validator: LengthRangeValidator(min: 6, max: 12, errorText: 'Enter your password minimal 6').call),
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
                                customNavigator(context,const LoginPage());

                              })
                      ]))
                ],
              ),
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
          customNavigator(context,const ChatsPage());

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
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
