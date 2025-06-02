import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class HomeNoteCard extends StatelessWidget {
  final Map<String, dynamic> note;
  final void Function(Map<String, dynamic>) onTap;

  const HomeNoteCard({required this.note, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(AppConstants.smallPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          '${note['date']} - ${note['day']}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          note['content'] ?? '',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: () => onTap(note),
      ),
    );
  }
}
