import 'package:path/path.dart'; //Ref: https://pub.dev/packages/path
import 'package:sqflite/sqflite.dart'; // Ref: https://pub.dev/packages/sqflite

class DatabaseHelper {
  static Future database() async {
    final databasePath = await getDatabasesPath();

    return openDatabase(join(databasePath, 'blogs_database.db'),
        onCreate: (database, version) {
      return database.execute(
          'CREATE TABLE blogs(id INTEGER PRIMARY KEY, title TEXT, content TEXT, imagePath TEXT)');
    }, version: 1);
  }

  static Future insert(Map<String, Object> data) async {
    final database = await DatabaseHelper.database();

    database.insert("blogs", data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getBlogsFromDB() async {
    final database = await DatabaseHelper.database();

    return database.query("blogs", orderBy: "id DESC");
  }

  static Future<List<Map<String, dynamic>>> getSearchBlogsFromDB(
      String keyword) async {
    final database = await DatabaseHelper.database();

    return database
        .query("blogs", where: 'title LIKE ?', whereArgs: ['%$keyword%']);
  }

  static Future delete(int id) async {
    final database = await DatabaseHelper.database();

    return database.delete('blogs', where: 'id = ?', whereArgs: [id]);
  }
}
