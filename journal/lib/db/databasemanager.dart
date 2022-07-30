import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class DatabaseManager {
  static String SQL_CREATE_SCHEME = 'assets/dbschema.txt';
  static String DATABASE_FILENAME = 'journal.sqlite3.db';
  
  late Database db; 

  DatabaseManager._({required Database database}) : db = database; 

  static DatabaseManager _instance = DatabaseManager._instance;  

  static Future initialize() async {
    String dbSchema = await getDBSchema(); 
    // await deleteDatabase(DATABASE_FILENAME);
    final db = await openDatabase(
      DATABASE_FILENAME, 
      version: 1,
      onCreate: (Database db, int version) async {
       createTables(db, dbSchema); 
      }
    );
    _instance = DatabaseManager._(database: db);
  }

  factory DatabaseManager.getInstance() {
    return _instance; 
  }

  static Future<String> getDBSchema() async {
    return await rootBundle.loadString(SQL_CREATE_SCHEME);
  }

  static void createTables(Database db, String sql) async {
    await db.execute(sql);
  }
}