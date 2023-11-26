import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteColumn {
  static final List<String> values = [
    /// Add all fields
    id, title, description
  ];

  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
}

class Note {

  static Future<Database> db() async {
    // Implement the code to open the SQLite database and return a reference
    // You might be using the `sqflite` package or another SQLite package

    // Example using sqflite package:
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'your_database.db'),
      onCreate: (db, version) async {
        // Define your table creation query here
      },
      version: 1,
    );
  }


  late String id;
  late String title;
  late String description;

  Note({required this.id, required this.title, required this.description});

  Note.fromMap(Map<String, dynamic> item)
      : id = item[NoteColumn.id],
        title = item[NoteColumn.title],
        description = item[NoteColumn.description];

  Map<String, Object> toMap() {
    return {
      NoteColumn.id: id,
      NoteColumn.title: title,
      NoteColumn.description: description,
    };
  }
}
