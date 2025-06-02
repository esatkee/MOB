import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Şifre alanları için decoration
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

// Normal input alanları için standart InputDecoration
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

// E-posta doğrulama fonksiyonu
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Please enter your email';
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Please enter a valid email';
  return null;
}

// Şifre doğrulama
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

// Hata mesajı
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

// Firebase hata kodlarını okunabilir mesaja çevirir
String firebaseErrorMessage(String code) {
  switch (code) {
    case 'weak-password':
      return 'Girilen şifre çok zayıf.';
    case 'email-already-in-use':
      return 'Bu e-posta adresi zaten kayıtlı.';
    case 'invalid-email':
      return 'Geçersiz e-posta adresi.';
    default:
      return 'Bir hata oluştu.';
  }
}


// Yeni kullanıcıyı Supabase veritabanına ekler
Future<void> insertUserToSupabase(String uid) async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('user').insert({'firebase_uid': uid}).select();

  // Eğer kullanıcı eklenememişse veya zaten varsa hata ver
  if (response == null || (response is List && response.isEmpty)) {
    throw Exception("User could not be inserted or already exists.");
  }
}
