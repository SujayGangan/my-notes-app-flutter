import 'package:flutter/material.dart';
import 'package:notes_app/screens/add_edit_notes_screen.dart';
import '../db/notes_database.dart';
import '../models/note.dart';
import '../widgets/note_item.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() {});
  }

  void _deleteNote(int id) async {
    await NotesDatabase.instance.delete(id);
    refreshNotes();
  }

  void _navigateToAddEditNote({Note? note}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddEditNoteScreen(note: note)),
    );
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.amber,
      ),
      body:
          notes.isEmpty
              ? const Center(child: Text('No notes yet.'))
              : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return NoteItem(
                    note: notes[index],
                    onEdit: () => _navigateToAddEditNote(note: notes[index]),
                    onDelete: () => _deleteNote(notes[index].id!),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
