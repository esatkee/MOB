import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

InputDecoration _passwordDecoration({
  required String label,
  required IconData icon,
  required VoidCallback onVisibilityToggle,
  required bool obscure,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    suffixIcon: IconButton(
      icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
      onPressed: onVisibilityToggle,
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );
}

InputDecoration _standardDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );
}

InputDecoration _inputDecoration(
    String label,
    IconData icon, {
      bool isPassword = false,
      VoidCallback? onVisibilityToggle,
      bool obscure = true,
    }) =>
    isPassword
        ? _passwordDecoration(label: label, icon: icon, onVisibilityToggle: onVisibilityToggle!, obscure: obscure)
        : _standardDecoration(label, icon);

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Please enter your email';
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Please enter a valid email';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Please enter a password';
  if (value.length < 6) return 'Password must be at least 6 characters';
  return null;
}

String? validateConfirmPassword(String? value, String original) {
  if (value == null || value.isEmpty) return 'Please confirm your password';
  if (value != original) return 'Passwords do not match';
  return null;
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

String firebaseErrorMessage(String code) {
  switch (code) {
    case 'weak-password':
      return 'The password provided is too weak.';
    case 'email-already-in-use':
      return 'The account already exists for that email.';
    case 'invalid-email':
      return 'The email address is invalid.';
    default:
      return 'An error occurred';
  }
}

Future<void> insertUserToSupabase(String uid) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('user').insert({'firebase_uid': uid}).select();

  if (response == null || (response is List && response.isEmpty)) {
    throw Exception("User could not be inserted or already exists.");
  }
}
