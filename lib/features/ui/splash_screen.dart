import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/features/auth/login_page.dart';
import 'package:firebase_real_time_data/features/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check login status using SharedPreferences
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // If user is logged in, navigate to HomePage, else go to LoginPage
    if (isLoggedIn) {
      // Delay navigation to give splash screen time to display
      Future.delayed(const Duration(seconds: 2), () {
        customNavigatorPushRemoveAll(context, const HomePage());
      });
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        customNavigatorPushRemoveAll(context, const LoginPage());
      });
    }
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SvgPicture.asset('assets/images/splash_logo.svg'),
                 const Text(
                  'Stay connected with your friends and family',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    customNavigatorPushRemoveAll(context, const LoginPage());
                  },
                  child: const Text('Start Messaging'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}