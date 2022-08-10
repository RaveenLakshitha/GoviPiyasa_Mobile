import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'BankCard.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE Card(id INTEGER PRIMARY KEY, cardNo TEXT, expiredate TEXT cvv TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> inserttodo(Bank todo) async {
    final db = await initializeDB();
    await db.insert(
      'Card',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Bank>> todos() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('Card');
    return queryResult.map((e) => Bank.fromMap(e)).toList();
  }

  Future<void> deletetodo(int id) async {
    final db = await initializeDB();
    await db.delete(
      'Card',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}