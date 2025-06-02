import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class StreakTracker {
  static const String _lastLoginKey = 'last_login_date';
  static const String _streakKey = 'login_streak';

  static Future<int> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    final lastLogin = prefs.getString(_lastLoginKey);
    int currentStreak = prefs.getInt(_streakKey) ?? 0;

    if (lastLogin == today) {
      // Already logged in today
      return currentStreak;
    }

    if (lastLogin != null) {
      final lastLoginDate = DateFormat('yyyy-MM-dd').parse(lastLogin);
      final yesterday = now.subtract(const Duration(days: 1));
      final isYesterday = DateFormat('yyyy-MM-dd').format(yesterday) ==
          DateFormat('yyyy-MM-dd').format(lastLoginDate);

      if (isYesterday) {
        currentStreak += 1;
      } else {
        currentStreak = 1; // Streak resets
      }
    } else {
      currentStreak = 1; // First login ever
    }

    // Save new values
    await prefs.setString(_lastLoginKey, today);
    await prefs.setInt(_streakKey, currentStreak);

    return currentStreak;
  }

  static Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }
}
