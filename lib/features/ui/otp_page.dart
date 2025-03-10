import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/features/ui/change_pass_page.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _OTPTEController = TextEditingController();

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
                'Your OTP',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 44),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: PinCodeTextField(
                  controller: _OTPTEController,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(milliseconds: 300),
                  appContext: context,
                ),
              ),
              const SizedBox(height: 44),
              ElevatedButton(
                onPressed: () {
                  customNavigator(context, const ChangePassPage());
                },
                child: const Text('NEXT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
