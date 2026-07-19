
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'ride.db');
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)',
      );
      await db.execute(
        'CREATE TABLE bookings(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, pickup TEXT, dropoff TEXT)',
      );
    });
  }

  Future<int> registerUser(Map<String, dynamic> user) async {
    final db = await database;
    return db.insert('users', user);
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final res = await db.query(
      'users',
      where: 'email=? AND password=?',
      whereArgs: [email, password],
    );
    return res.isNotEmpty ? res.first : null;
  }

  Future<int> insertBooking(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('bookings', data);
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await database;
    return db.query('bookings');
  }

  Future<int> updateBooking(Map<String, dynamic> data) async {
    final db = await database;
    return db.update('bookings', data, where: 'id=?', whereArgs: [data['id']]);
  }

  Future<int> deleteBooking(int id) async {
    final db = await database;
    return db.delete('bookings', where: 'id=?', whereArgs: [id]);
  }
}
