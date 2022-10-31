import 'package:resto_app/data/models/restaurant_list_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tabelFavorite = 'favorites';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase('$path/restoapp.db', onCreate: (db, version) async {
      await db.execute('''CREATE TABLE $_tabelFavorite(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        city TEXT,
        pictureId TEXT,
        rating DOUBLE
      )''');
    }, version: 1);
    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> addFavorite(RestaurantListModel resto) async {
    final db = await database;

    await db!.insert(_tabelFavorite, resto.toJson());
  }

  Future<List<RestaurantListModel>> getFavoriteList() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tabelFavorite);

    return results.map((res) => RestaurantListModel.fromJson(res)).toList();
  }

  Future<Map> getFavoriteById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results =
        await db!.query(_tabelFavorite, where: 'id = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;

    await db!.delete(_tabelFavorite, where: 'id = ?', whereArgs: [id]);
  }
}
