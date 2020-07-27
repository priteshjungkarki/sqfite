import 'dart:async';
import 'dart:io';
import 'package:database/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableUser = 'userTable';
  final String columnId = 'id';
  final String columnUsername = 'username';
  final String columnUserPassword = 'password';

  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'maindb.db');

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE Table $tableUser($columnId int PRIMARY KEY,$columnUsername TEXT,$columnUserPassword TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableUser", user.toMap());
    return res;
  }

  Future<List> getAllUsers(User user) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

  Future<int> getCount(User user) async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableUser"));
  }

  Future<User> geUsers(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery("SELECT * FROM $tableUser where $columnId=$id");
    if (result.length == 0) return null;
    return User.fromMap(result.first);
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    int res =
        await dbClient.delete(tableUser, where: "$columnId", whereArgs: [id]);
    return res;
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.update(tableUser, user.toMap(),
        where: "$columnId", whereArgs: [user.id]);
    return res;
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
