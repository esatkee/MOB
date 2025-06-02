import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart' show supabase;

class HomeHelper {
  static Future<List<Map<String, dynamic>>> fetchNotes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    try {
      final response = await supabase
          .from('diary')
          .select()
          .eq('firebase_uid', user.uid)
          .order('date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteNote(String diaryId) async {
    try {
      await supabase.from('diary').delete().eq('diary_id', diaryId);
    } catch (e) {
      rethrow;
    }
  }
}
