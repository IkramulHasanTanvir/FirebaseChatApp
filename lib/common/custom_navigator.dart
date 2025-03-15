import 'package:flutter/material.dart';

void customNavigatorPushRemoveAll(BuildContext context,Widget page){
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
          (_) => false);
}
void customNavigatorPush(BuildContext context,Widget page){
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ));
}