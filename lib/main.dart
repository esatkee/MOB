import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase paketi

import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_page.dart';
import 'screens/diary_detail.dart';
import 'screens/profile_page.dart';
import 'screens/settings_page.dart';
import 'providers/settings_provider.dart';
import 'constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlatıyoruz
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Supabase'i başlatıyoruz
  await Supabase.initialize(
    url: 'https://jspsknitanbilrnavgmu.supabase.co', // Supabase projenizin URL'si
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzcHNrbml0YW5iaWxybmF2Z211Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3MjQyNTMsImV4cCI6MjA2NDMwMDI1M30.Q_mFBwBhzfgdxVDXV11xjvmtSkyzgXiB_AWIQQ9y98E', // Supabase projenizin public anahtarı
  );

  runApp(const MyApp());
}

// Supabase istemcisi global olarak erişilebilir
final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ayar sağlayıcısını başlatıyoruz
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider()..init(),
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          final isDark = settings.isDarkMode;
          final primaryColor = settings.themeColor;
          final baseTextSize = AppConstants.mediumTextSize;
          final scaleFactor = settings.textSize / baseTextSize;
          
          return MaterialApp(
            title: 'Diary+', // Uygulama başlığı
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: primaryColor,
                brightness: isDark ? Brightness.dark : Brightness.light,
              ),
              cardTheme: CardTheme(
                color: isDark ? Colors.grey[800] : Colors.white,
                elevation: AppConstants.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontSize: AppConstants.displayTextSize * scaleFactor,
                  fontWeight: AppConstants.boldFontWeight,
                  color: isDark ? Colors.white : Colors.black,
                ),
                displayMedium: TextStyle(
                  fontSize: AppConstants.titleTextSize * scaleFactor,
                  fontWeight: AppConstants.boldFontWeight,
                  color: isDark ? Colors.white : Colors.black,
                ),
                displaySmall: TextStyle(
                  fontSize: AppConstants.headingTextSize * scaleFactor,
                  fontWeight: AppConstants.semiBoldFontWeight,
                  color: isDark ? Colors.white : Colors.black,
                ),
                headlineMedium: TextStyle(
                  fontSize: AppConstants.extraLargeTextSize * scaleFactor,
                  fontWeight: AppConstants.semiBoldFontWeight,
                  color: isDark ? Colors.white : Colors.black,
                ),
                headlineSmall: TextStyle(
                  fontSize: AppConstants.largeTextSize * scaleFactor,
                  fontWeight: AppConstants.mediumFontWeight,
                  color: isDark ? Colors.white : Colors.black,
                ),
                titleLarge: TextStyle(
                  fontSize: AppConstants.mediumTextSize * scaleFactor,
                  fontWeight: AppConstants.mediumFontWeight,
                  color: isDark ? Colors.white : Colors.black,
                ),
                bodyLarge: TextStyle(
                  fontSize: AppConstants.smallTextSize * scaleFactor,
                  fontWeight: AppConstants.regularFontWeight,
                  color: isDark ? Colors.white : Colors.black,
                ),
                bodyMedium: TextStyle(
                  fontSize: AppConstants.extraSmallTextSize * scaleFactor,
                  fontWeight: AppConstants.regularFontWeight,
                  color: isDark ? Colors.white : Colors.black,
                ),
                bodySmall: TextStyle(
                  fontSize: (AppConstants.extraSmallTextSize * 0.8) * scaleFactor,
                  fontWeight: AppConstants.regularFontWeight,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              dividerTheme: DividerThemeData(
                color: isDark ? Colors.grey[700] : AppConstants.dividerColor,
              ),
              switchTheme: SwitchThemeData(
                thumbColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return primaryColor;
                  }
                  return isDark ? Colors.grey[400] : Colors.grey[600];
                }),
                trackColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return primaryColor.withOpacity(0.5);
                  }
                  return isDark ? Colors.grey[700] : Colors.grey[300];
                }),
              ),
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginPage(), // Giriş ekranı
              '/register': (context) => const RegisterPage(), // Kayıt ekranı
              '/home': (context) => const HomePage(), // Ana sayfa
              '/diary': (context) => EditNotePage(), // Günlük detay ekranı
              '/profile': (context) => const ProfilePage(), // Profil ekranı
              '/settings': (context) => const SettingsPage(), // Ayarlar ekranı
            },
          );
        },
      ),
    );
  }
}


extension ContextExtension on BuildContext {
  // Ekranın alt kısmında bilgi mesajı gösteriyor
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).colorScheme.primary,
      ),
    );
  }
}
