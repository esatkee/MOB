import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/texts.dart';
import '../../functions/home_helper.dart';
import '../screens/diary_detail.dart';

void showNoteDetailDialog({
  required BuildContext context,
  required Map<String, dynamic> note,
  required VoidCallback onDelete,
  required VoidCallback onEdit,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note['date'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Text(
                note['content'] ?? '',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      AppTexts.edit,
                      style: TextStyle(color: colorScheme.primary),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
                      );
                      onEdit();
                    },
                  ),
                  TextButton(
                    child: Text(
                      AppTexts.delete,
                      style: TextStyle(color: colorScheme.error),
                    ),
                    onPressed: () async {
                      await HomeHelper.deleteNote(note['diary_id']);
                      Navigator.pop(context);
                      onDelete();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
