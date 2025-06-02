import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../constants/texts.dart';
import '../functions/diary_helper.dart';
import '../widgets/note_input.dart';
import '../widgets/action_button.dart';
import '../widgets/custom_appbar.dart';

class EditNotePage extends StatefulWidget {
  final Map<String, dynamic>? note;

  const EditNotePage({Key? key, this.note}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _textController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.note?['text'] ?? widget.note?['content'] ?? '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    setState(() => _isLoading = true);

    final result = await DiaryHelper.saveOrUpdateNote(
      context: context,
      text: _textController.text.trim(),
      existingNote: widget.note,
    );

    if (!mounted) return;

    if (result != null) {
      Navigator.pop(context, result);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.note != null;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: CustomAppBar(
        title: isEditing ? AppTexts.editNote : AppTexts.newNote,
        showBackButton: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                  vertical: AppConstants.largePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NoteTextInput(controller: _textController),
                    const SizedBox(height: AppConstants.defaultPadding),
                    // Image preview kaldırıldı
                  ],
                ),
              ),
            ),
            ActionButtons(
              isLoading: _isLoading,
              onCancel: () => Navigator.pop(context),
              onSave: _saveNote,
            ),
          ],
        ),
      ),
    );
  }
}
