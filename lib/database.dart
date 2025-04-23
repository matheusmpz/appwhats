import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String tableContato = 'contatos';

  static Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'dbContatos.db'),
      onCreate: (db, version) {
        return db.execute('''
                CREATE TABLE $tableContato(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  nome TEXT NOT NULL,
                  telefone TEXT NOT NULL
                )
              ''');
      },
      version: 1,
    );
  }

  static Future<void> createContato(String nome, String telefone) async {
    final db = await getDatabase();
    await db.insert(tableContato, {"nome": nome, "telefone": telefone});
  }

  static Future<List<Map<String, dynamic>>> getContatos() async {
    final db = await getDatabase();
    return await db.query(tableContato);
  }

  static Future<void> updateContato(
      int id, String nome, String telefone) async {
    final db = await getDatabase();
    await db.update(
      tableContato,
      {
        "nome": nome,
        "telefone": telefone,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteContato(int id) async {
    final db = await getDatabase();
    await db.delete(
      tableContato,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
