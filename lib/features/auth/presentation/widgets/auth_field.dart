import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final TextInputType keyboardType; // Add keyboard type

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.keyboardType = TextInputType.text, // Default to text
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType, // Use the passed keyboard type
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$hintText is missing!";
        }
        if (keyboardType == TextInputType.phone &&
            !RegExp(r'^\d+$').hasMatch(value)) {
          return "Enter a valid phone number!";
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
