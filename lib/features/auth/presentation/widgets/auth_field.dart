import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final TextInputType keyboardType;

  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = !widget.isObscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.hintText,
        // Only show the suffix icon for password fields
        suffixIcon: widget.isObscureText
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
      ),
      validator: (value) {
        String trimmedValue = value?.trim() ?? ""; // Trim the input
        if (trimmedValue.isEmpty) {
          return "${widget.hintText} is missing!";
        }
        if (widget.keyboardType == TextInputType.emailAddress &&
            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmedValue)) {
          return "Enter a valid email!";
        }
        if (widget.keyboardType == TextInputType.phone &&
            !RegExp(r'^\d+$').hasMatch(trimmedValue)) {
          return "Enter a valid phone number!";
        }
        return null;
      },
      obscureText: widget.isObscureText && !_passwordVisible,
    );
  }
}
