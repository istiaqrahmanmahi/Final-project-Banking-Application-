import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final label;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final keyboardType;
  final validator;

  const InputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    required this.keyboardType,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,

      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        hintStyle: const TextStyle(
          color:Colors.blueGrey,
          fontSize: 14,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color:Colors.blueGrey)
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor:Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color:Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color:Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal:16.0,
          vertical: 16.0,
        ),
      ),
    );
  }
}
