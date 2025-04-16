import 'package:flutter/material.dart';
import '../db/notes_database.dart';
import '../models/note.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title);
    _descriptionController = TextEditingController(
      text: widget.note?.description,
    );
  }

  // void _saveNote() async {
  //   if (_formKey.currentState!.validate()) {
  //     final newNote = Note(
  //       id: widget.note?.id,
  //       title: _titleController.text,
  //       description: _descriptionController.text,
  //     );
  //     if (widget.note == null) {
  //       await NotesDatabase.instance.create(newNote);
  //     } else {
  //       await NotesDatabase.instance.update(newNote);
  //     }
  //     Navigator.of(context).pop();
  //   }
  // }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final newNote = Note(
        id: widget.note?.id,
        title: _titleController.text,
        description: _descriptionController.text,
      );

      // Store context in a local variable
      final currentContext = context;

      if (widget.note == null) {
        await NotesDatabase.instance.create(newNote);
      } else {
        await NotesDatabase.instance.update(newNote);
      }

      // Use the stored context to navigate
      if (currentContext.mounted) {
        Navigator.of(currentContext).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator:
                    (value) => value!.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveNote, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
