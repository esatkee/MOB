import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart' show supabase;

class HomeHelper {
  // Günlük kayıtlarını veritabanından çeker
  static Future<List<Map<String, dynamic>>> fetchNotes() async {
    final user = FirebaseAuth.instance.currentUser;

    // Eğer kullanıcı giriş yapmamışsa boş liste döner
    if (user == null) return [];

    try {
      // Kullanıcının UID'sine göre günlük kayıtlarını çeker
      final response = await supabase
          .from('diary')
          .select()
          .eq('firebase_uid', user.uid)
          .order('date', ascending: false); // Tarihe göre tersten sırala (en yeni en üstte)

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  // Belirtilen günlük ID'sine sahip kaydı siler
  static Future<void> deleteNote(int diaryId) async {
    try {
      await supabase.from('diary').delete().eq('diary_id', diaryId);
    } catch (e) {
      rethrow;
    }
  }
}
