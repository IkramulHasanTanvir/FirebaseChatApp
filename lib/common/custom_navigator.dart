import 'package:flutter/material.dart';

void customNavigator(BuildContext context,Widget page){
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
          (_) => false);
}