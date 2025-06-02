import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_settings.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        themeColor INTEGER,
        textSize REAL,
        darkMode INTEGER,
        notificationsEnabled INTEGER,
        soundEnabled INTEGER,
        vibrationEnabled INTEGER
      )
    ''');

    // Insert default settings
    await db.insert('settings', {
      'themeColor': 0xFF008080,
      'textSize': 24.0,
      'darkMode': 0,
      'notificationsEnabled': 1,
      'soundEnabled': 1,
      'vibrationEnabled': 1,
    });
  }
}