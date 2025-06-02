import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/constants.dart';
import '../../constants/texts.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';
import '../../functions/home_helper.dart';
import '../widgets/home_card.dart';
import '../widgets/note_dialog.dart';
import '../screens/diary_detail.dart';

// Stateful bir ana sayfa widget'ı
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Ana sayfanın durumunu yöneten sınıf
class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }
// Asenkron olarak notları veritabanından çeken fonksiyon
  Future<void> _fetchNotes() async {
    try {
      final notes = await HomeHelper.fetchNotes();
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notlar yüklenirken hata oluştu: $e')),
      );
    }
  }

  void _onNoteTap(Map<String, dynamic> note) {
    showNoteDetailDialog(
      context: context,
      note: note,
      onDelete: () {
        setState(() => _notes.removeWhere((n) => n['diary_id'] == note['diary_id']));
      },
      onEdit: _fetchNotes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.appTitle),
      drawer: DrawerMenu(onAddNote: (_) => _fetchNotes()),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? Center(child: Text(AppTexts.noDiary))
          : ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return HomeNoteCard(note: _notes[index], onTap: _onNoteTap);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditNotePage()),
          );
          if (newNote != null) _fetchNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
