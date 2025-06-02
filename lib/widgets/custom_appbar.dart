import 'package:flutter/material.dart';
import '../constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final double elevation;
  final double height;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.elevation = 0.0,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: AppConstants.largeTextSize,
          fontWeight: AppConstants.semiBoldFontWeight,
        ),
      ),
      automaticallyImplyLeading: showBackButton,
      backgroundColor: colorScheme.primary,
      elevation: elevation,
      actions: actions,
      iconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
