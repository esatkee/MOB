import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart' show supabase;
import '../constants/constants.dart';

class DiaryHelper {
  // Yeni bir günlük kaydı oluşturur veya mevcut kaydı günceller
  static Future<Map<String, dynamic>?> saveOrUpdateNote({
    required BuildContext context,
    required String text,
    Map<String, dynamic>? existingNote,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    // Kullanıcı giriş yapmamışsa hata mesajı göster
    if (user == null) {
      showSnackBar(context, 'User not authenticated.', isError: true);
      return null;
    }

    // Günlük içeriği boşsa hata mesajı göster
    if (text.trim().isEmpty) {
      showSnackBar(context, 'Günlük boş olamaz.', isError: true);
      return null;
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final weekday = DateFormat('EEEE').format(now);
    final uid = user.uid;

    try {
      // Yeni bir günlük oluşturuluyorsa
      if (existingNote == null) {
        final response = await supabase.from('diary').insert({
          'date': formattedDate,
          'day': weekday,
          'content': text,
          'firebase_uid': uid,
        }).select().single();

        showSnackBar(context, 'Günlük Kaydedildi.');
        return {
          'date': formattedDate,
          'weekday': weekday,
          'text': text,
          'diary_id': response['diary_id'],
          'firebase_uid': uid,
        };
      } else {
        // Mevcut günlük güncelleniyorsa
        final diaryId = existingNote['diary_id'];
        await supabase.from('diary').update({
          'content': text,
          'day': weekday,
        }).eq('diary_id', diaryId);

        showSnackBar(context, 'Günlük Güncellendi.');
        return {
          ...existingNote,
          'text': text,
          'weekday': weekday,
        };
      }
    } catch (e) {
      showSnackBar(context, 'Günlük kaydedilirken bir hata meydana geldi.', isError: true);
      return null;
    }
  }

  // Snackbar ile kullanıcıya mesaj gösterir
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppConstants.errorColor : AppConstants.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
      ),
    );
  }
}
