# Diary+

A diary app built with Flutter, Firebase and Supabase.

Write and edit entries, manage your profile and customise the theme. Built as a team project.

**Team:** Esat Küçe · Ritvan Angous · Muhammed Sait Yıldırım

My contribution: login, registration, diary detail screens and Firebase integration.


<details>
<summary>Setup & technical notes</summary>

### Getting started

Use a Flutter SDK compatible with Dart `^3.7.2` (see `pubspec.yaml`).

```bash
flutter pub get
```

Configure your own Firebase project and platform files, then set up Supabase for the user, diary and province data used by the app. Update the connection configuration in `lib/main.dart` and review the queries in `lib/functions/` before running:

```bash
flutter run
```

Backend services and their access rules must be configured separately; this repository is the Flutter client. The nested `supabase_quickstart/` folder is a separate sample, not the main application entry point.

### Code structure

- `lib/screens/` — login, registration, diary, home, profile and settings screens.
- `lib/functions/` — authentication, database, diary and streak helpers.
- `lib/widgets/` — shared UI components.
- `lib/providers/` — application settings state.
- `lib/constants/` — shared constants and text styles.

### Team contributions

- **Ritvan Angous:** profile and settings screens; Supabase and SQLite database design.
- **Muhammed Sait Yıldırım:** home screen, Firebase, Supabase and project reporting.
- **Shared work:** drawer navigation.

</details>
