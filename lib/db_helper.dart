import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'contact.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE contacts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            contact TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertContact(Contact contact) async {
    final dbClient = await db;
    return await dbClient.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  Future<int> updateContact(Contact contact) async {
    final dbClient = await db;
    return await dbClient.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> contactExists(String name, String number) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'contacts',
      where: 'name = ? OR contact = ?',
      whereArgs: [name, number],
    );
    return maps.isNotEmpty;
  }
}
