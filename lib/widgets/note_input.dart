import 'package:flutter/material.dart';
import '../constants/constants.dart';

class NoteTextInput extends StatelessWidget {
  final TextEditingController controller;

  const NoteTextInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: AppConstants.mediumTextSize,
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Günlüğünüzü yazın...',
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            fontSize: AppConstants.mediumTextSize,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
