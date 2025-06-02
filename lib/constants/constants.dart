import 'package:flutter/material.dart';

class AppConstants {
  // Color Palette - Teal & Cream Theme
  static const Color primaryColor = Color(0xFF008080);       // Teal
  static const Color primaryLight = Color(0xFF4CB0AF);       // Light Teal
  static const Color primaryDark = Color(0xFF005457);        // Dark Teal
  static const Color secondaryColor = Color(0xFFF5F5DC);     // Cream
  static const Color secondaryDark = Color(0xFFE5E5C5);      // Darker Cream
  static const Color accentColor = Color(0xFFFFA000);        // Amber accent
  static const Color backgroundColor = Color(0xFFFAFAF5);    // Off-white
  static const Color textColor = Color(0xFF333333);          // Dark gray
  static const Color textLight = Color(0xFF666666);          // Medium gray
  static const Color errorColor = Color(0xFFD32F2F);         // Red
  static const Color successColor = Color(0xFF388E3C);       // Green
  static const Color warningColor = Color(0xFFFFA000);       // Amber
  static const Color infoColor = Color(0xFF1976D2);          // Blue
  static const Color cardColor = Colors.white;               // White cards
  static const Color dividerColor = Color(0xFFE0E0E0);       // Light gray

  // Available theme colors
  static const List<Color> availableColors = [
    Color(0xFF008080), // Teal
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFFF44336), // Red
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFF795548), // Brown
  ];
  static const List<double> availableTextSizes = [
    extraSmallTextSize,
    smallTextSize,
    mediumTextSize,
    largeTextSize,
    extraLargeTextSize,
    headingTextSize,
  ];


  // Text sizes
  static const double extraSmallTextSize = 20.0;
  static const double smallTextSize = 22.0;
  static const double mediumTextSize = 24.0;
  static const double largeTextSize = 26.0;
  static const double extraLargeTextSize = 28.0;
  static const double headingTextSize = 30.0;
  static const double titleTextSize = 32.0;
  static const double displayTextSize = 34.0;

  // Font weights
  static const FontWeight lightFontWeight = FontWeight.w300;
  static const FontWeight regularFontWeight = FontWeight.w400;
  static const FontWeight mediumFontWeight = FontWeight.w500;
  static const FontWeight semiBoldFontWeight = FontWeight.w600;
  static const FontWeight boldFontWeight = FontWeight.w700;

  // Spacing & Padding
  static const double extraSmallPadding = 4.0;
  static const double smallPadding = 8.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  // Border radius
  static const double smallBorderRadius = 4.0;
  static const double borderRadius = 8.0;
  static const double largeBorderRadius = 12.0;
  static const double extraLargeBorderRadius = 16.0;

  // Button dimensions
  static const double buttonHeight = 48.0;
  static const double buttonMinWidth = 88.0;
  static const double buttonBorderRadius = 8.0;
  static const double buttonElevation = 2.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration animationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Icon sizes
  static const double extraSmallIconSize = 12.0;
  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  // App bar dimensions
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 4.0;

  // Drawer dimensions
  static const double drawerWidth = 280.0;
  static const double drawerHeaderHeight = 120.0;

  // Card dimensions
  static const double cardElevation = 2.0;
  static const double noteCardWidth = 160.0;
  static const double noteCardHeight = 200.0;
  static const double noteCardSpacing = 16.0;

  // Input fields
  static const double inputFieldHeight = 48.0;
  static const double inputBorderWidth = 1.0;
  static const double inputBorderRadius = 8.0;

  // Search bar
  static const double searchBarHeight = 48.0;

  // Profile images
  static const double smallAvatarSize = 40.0;
  static const double mediumAvatarSize = 60.0;
  static const double largeAvatarSize = 80.0;
  static const double profileImageSize = 120.0;
  static const double avatarRadius = 60.0;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String notesCollection = 'notes';
  static const String diaryCollection = 'diary';
  static const String profilesCollection = 'profiles';

  // Asset Paths
  static const String defaultAvatarPath = 'assets/images/avatar.png';
  static const String logoPath = 'assets/images/logo.png';
  static const String placeholderImagePath = 'assets/images/placeholder.jpg';

  // Route Names
  static const String homeRoute = '/home';
  static const String loginRoute = '/';
  static const String registerRoute = '/register';
  static const String diaryRoute = '/diary';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String aboutRoute = '/about';
  static const String helpRoute = '/help';

  // Shared Preferences Keys
  static const String themeModeKey = 'theme_mode';
  static const String primaryColorKey = 'primary_color';
  static const String fontSizeKey = 'font_size';
  static const String userDataKey = 'user_data';

  // Other constants
  static const int passwordMinLength = 6;
  static const int otpLength = 6;
  static const int maxDiaryEntries = 1000;
  static const int maxImageSizeMB = 5;
}