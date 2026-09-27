# Diary+

A Flutter diary application built as a team project. Users can sign in, write and manage diary entries, edit their profiles and customise the app's appearance.

## Features

- Email/password and social sign-in workflows using Firebase Authentication.
- Diary entry creation, editing and deletion.
- Profile editing with Supabase-backed data.
- Theme and text-size preferences managed with Provider.
- Local settings and writing streak tracking.

## Stack

Flutter, Dart, Firebase Authentication, Supabase, Provider, SQLite and SharedPreferences.

## Getting started

Use a Flutter SDK compatible with Dart `^3.7.2` (see `pubspec.yaml`).

```bash
flutter pub get
```

Configure your own Firebase project and platform files, then set up Supabase for the user, diary and province data used by the app. Update the connection configuration in `lib/main.dart` and review the queries in `lib/functions/` before running:

```bash
flutter run
```

Backend services and their access rules must be configured separately; this repository is the Flutter client. The nested `supabase_quickstart/` folder is a separate sample, not the main application entry point.

## Code structure

- `lib/screens/` — login, registration, diary, home, profile and settings screens.
- `lib/functions/` — authentication, database, diary and streak helpers.
- `lib/widgets/` — shared UI components.
- `lib/providers/` — application settings state.
- `lib/constants/` — shared constants and text styles.

## Team contributions

- **Esat Küçe:** login, registration, diary detail screens and Firebase development.
- **Ritvan Angous:** profile and settings screens; Supabase and SQLite database design.
- **Muhammed Sait Yıldırım:** home screen, Firebase, Supabase and project reporting.
- **Shared work:** drawer navigation.

## Türkçe

Diary+, günlük yazma ve düzenleme, profil yönetimi ve tema ayarları sunan bir ekip projesidir. Giriş, kayıt ve günlük detay ekranları ile Firebase geliştirmesinde görev aldım.
