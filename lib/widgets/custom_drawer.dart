import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../constants/constants.dart';
import '../constants/texts.dart';

class DrawerMenu extends StatelessWidget {
  final void Function(Map<String, String>)? onAddNote;

  const DrawerMenu({super.key, this.onAddNote});

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);

    if (route == '/diary') {
      Navigator.pushNamed(context, route).then((_) {
        onAddNote?.call({});
      });
    } else {
      if (ModalRoute.of(context)?.settings.name != route) {
        Navigator.pushReplacementNamed(context, route);
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppTexts.logout, style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          )),
          content: Text(AppTexts.logoutConfirm, style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          )),
          actions: [
            TextButton(
              child: Text(AppTexts.cancel, style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
              )),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppTexts.yes, style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
              )),
              onPressed: () async {
                Navigator.of(context).pop();

                try {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();

                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppTexts.logoutSuccess)),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${AppTexts.logoutError}$e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Theme(
            data: theme.copyWith(
              colorScheme: colorScheme.copyWith(
                primary: colorScheme.primary,
                onPrimary: colorScheme.onPrimary,
              ),
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primary,
              ),
              accountName: Text(
                user?.displayName ?? AppTexts.noPhoto,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                user?.email ?? AppTexts.email,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage(AppConstants.defaultAvatarPath) as ImageProvider,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.looks_one, color: colorScheme.primary),
            title: Text(AppTexts.home, style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            )),
            onTap: () => _navigate(context, AppConstants.homeRoute),
          ),
          ListTile(
            leading: Icon(Icons.looks_two, color: colorScheme.primary),
            title: Text(AppTexts.addDiary, style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            )),
            onTap: () => _navigate(context, AppConstants.diaryRoute),
          ),
          ListTile(
            leading: Icon(Icons.person, color: colorScheme.primary),
            title: Text(AppTexts.profile, style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            )),
            onTap: () => _navigate(context, AppConstants.profileRoute),
          ),
          Divider(color: colorScheme.outline),
          ListTile(
            leading: Icon(Icons.settings, color: colorScheme.primary),
            title: Text(AppTexts.settings, style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            )),
            onTap: () => _navigate(context, AppConstants.settingsRoute),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: colorScheme.primary),
            title: Text(AppTexts.logout, style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            )),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
