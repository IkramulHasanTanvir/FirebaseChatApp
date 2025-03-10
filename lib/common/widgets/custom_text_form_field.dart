import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key,
      required this.controller,
      this.obscureText = false,
      required this.hint,
      this.validator});

  final TextEditingController controller;
  final bool obscureText;
  final String hint;
  final FieldValidator? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(hintText: hint),
      validator: validator?.call,
    );
  }
}
