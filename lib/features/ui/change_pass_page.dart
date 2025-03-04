import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/features/auth/login_page.dart';
import 'package:flutter/material.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _newPassTEController = TextEditingController();

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
                'Change Password',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 44),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _passwordTEController,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  }),
              const SizedBox(height: 16),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _newPassTEController,
                  decoration: const InputDecoration(hintText: 'New Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null;
                  }),
              const SizedBox(height: 44),
              ElevatedButton(
                  onPressed: () {
                    customNavigator(context, const LoginPage());
                  },
                  child: const Text('CONFIRM')),
            ],
          ),
        ),
      ),
    );
  }
}
