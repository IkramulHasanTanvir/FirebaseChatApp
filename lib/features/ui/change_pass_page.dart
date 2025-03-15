import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/common/widgets/custom_text_form_field.dart';
import 'package:firebase_real_time_data/features/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key,});


  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final TextEditingController _passwordTEController = TextEditingController(); // Controller for current password
  final TextEditingController _newPassTEController = TextEditingController(); // Controller for new password

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
              CustomTextFormField(
                controller: _passwordTEController,
                hint: 'Current Password',
                obscureText: true,
                validator: LengthRangeValidator(
                    min: 6,
                    max: 12,
                    errorText: 'Password must be 6-12 characters'),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _newPassTEController,
                hint: 'New Password',
                obscureText: true,
                validator: LengthRangeValidator(
                    min: 6,
                    max: 12,
                    errorText: 'Password must be 6-12 characters'),
              ),
              const SizedBox(height: 44),
              ElevatedButton(
                  onPressed: () {
                    // Add password change logic here before navigating
                    customNavigatorPushRemoveAll(context, const LoginPage());
                  },
                  child: const Text('CONFIRM')),
            ],
          ),
        ),
      ),
    );
  }
}
