import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/features/auth/signup_page.dart';
import 'package:firebase_real_time_data/features/ui/chats_page.dart';
import 'package:firebase_real_time_data/features/ui/forgot_pass_page.dart';
import 'package:firebase_real_time_data/features/ui/home_page.dart';
import 'package:firebase_real_time_data/firebase_services/firebase_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          customNavigator(context, const ForgotPassPage());

                        },
                        child: const Text('Forgot Password',style: TextStyle(color: Colors.amber),),
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
                          style: const TextStyle(color: Colors.amber),
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
          customNavigator(context, const ChatsPage());
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
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
