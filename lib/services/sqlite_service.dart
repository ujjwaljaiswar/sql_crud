import 'package:flutter/cupertino.dart';
import 'package:sql_crud/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const String databaseName = "database.db";
  static Database? db;

  static Future<Database>initizateDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return db ??
        await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
              await createTables(db);
            });
  }

  static Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS Notes (
        Id TEXT NOT NULL,
        Title TEXT NOT NULL,
        Description TEXT NOT NULL,
      )      
      """);
  }

  static Future<int> createItem(Note note) async {
    final db = await SqliteService.initizateDb();
    final id = await db.insert('Notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }


  // Read all notes
  static Future<List<Note>> getItems() async {
    final db = await SqliteService.initizateDb();
    final List<Map<String, Object?>> queryResult = await db.query('Notes');
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SqliteService.db!;
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

//update
  static Future<int> updateItem(
      int id, String title, String? descrption) async {
    final db = await Note.db();

    final data = {
      'title': title,
      'description': descrption,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await Note.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    }
    catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }


}
