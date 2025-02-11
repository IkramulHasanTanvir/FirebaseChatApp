import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_real_time_data/firebase_options.dart';
import 'package:firebase_real_time_data/login_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
        fixedSize: const Size.fromWidth(double.maxFinite),
        foregroundColor: Colors.black,
      ))),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
