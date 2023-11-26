import 'package:flutter/material.dart';
import 'package:sql_crud/models/note.dart';

import '../../services/sqlite_service.dart';

class AddEditNote extends StatefulWidget {
  const AddEditNote({Key? key}) : super(key: key);

  @override
  _AddEditNoteState createState() => _AddEditNoteState();
}

class _AddEditNoteState extends State<AddEditNote> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(247, 250, 252, 1.0),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(94, 114, 228, 1.0),
          elevation: 0.0,
          title: const Text('Add or edit a note'),
        ),
        body: const MyCustomForm());
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  final _formKey = GlobalKey<FormState>();
  late String desc, title;

  // Insert a new data to the database
  Future<void> addItem() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Note n = Note(
        title: title,
        description: desc,
        id: "001",
      );
      await SqliteService.createItem(n);
    }
  }

// Update an existing data
  Future<void> updateItem(int id) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await SqliteService.updateItem(
        id,
        title,
        desc,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Title';
                }
                return null;
              }, onChanged: (value) {
            setState(() {
              title = value;
            });
          }),
          TextFormField(
            // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some Description';
                }
                return null;
              }, onChanged: (value) {
            setState(() {
              desc = value;
            });
          }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // In the real world,
                  // you'd often call a server or save the information in a database.

                  Note n = Note(
                    title: title,
                    description: desc,
                    id: "001",
                  );
                  Navigator.of(context).pop();
                  SqliteService.createItem(n);
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
