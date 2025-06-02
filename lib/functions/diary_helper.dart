import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart' show supabase;
import '../constants/constants.dart';

class DiaryHelper {
  static Future<Map<String, dynamic>?> saveOrUpdateNote({
    required BuildContext context,
    required String text,
    Map<String, dynamic>? existingNote,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showSnackBar(context, 'User not authenticated.', isError: true);
      return null;
    }

    if (text.trim().isEmpty) {
      showSnackBar(context, 'Günlük boş olamaz.', isError: true);
      return null;
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final weekday = DateFormat('EEEE').format(now);
    final uid = user.uid;

    try {
      if (existingNote == null) {
        final response = await supabase.from('diary').insert({
          'date': formattedDate,
          'day': weekday,
          'content': text,
          'firebase_uid': uid,
        }).select().single();

        showSnackBar(context, 'Note saved.');
        return {
          'date': formattedDate,
          'weekday': weekday,
          'text': text,
          'diary_id': response['diary_id'],
          'firebase_uid': uid,
        };
      } else {
        final diaryId = existingNote['diary_id'];
        await supabase.from('diary').update({
          'content': text,
          'day': weekday,
        }).eq('diary_id', diaryId);

        showSnackBar(context, 'Günlük Kaydedildi.');
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
