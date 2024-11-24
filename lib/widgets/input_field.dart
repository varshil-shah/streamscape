import 'package:flutter/material.dart';
import 'package:streamscape/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white60 : Colors.black54,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white30 : Colors.black26,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      ),
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
