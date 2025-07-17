import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;
  static Future<Database> getDB() async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await createDB();
      return _database!;
    }
  }

  static Future<Database> createDB() async {
    var databasePath = await getDatabasesPath();
    // var databaseFile="$databasePath/student.db";
    var databaseFile = join(databasePath, "student5.db");
    return openDatabase(
      databaseFile,
      version: 1,
      onCreate: (db, version) {
        return db.execute("""
        CREATE TABLE "student" (
          "id"  INTEGER,
          "first_name"  TEXT,
          "last_name"  TEXT,
          "gender"  TEXT,
          "dob"  TEXT,
          "profile" TEXT,
          PRIMARY KEY("id" AUTOINCREMENT)
);
        """);
      },
    );
  }

  static void insertStudent({
    required String fn,
    required String ln,
    required String gender,
    required String dob,
    required String profile,
  }) async {
    var db = await getDB();
    db.insert("student", {
      "first_name": fn,
      "last_name ": ln,
      "gender ": gender,
      "dob": dob,
      "profile": profile,
    });
  }

  static Future<List<Map<String, dynamic>>> readStudents() async {
    var db = await getDB();
    return db.query("student");
  }

  static void deleteStudent(int id) async {
    var db = await getDB();

    db.delete(
      "student",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static void updateStudent({
    required String fn,
    required String ln,
    required String gender,
    required String dob,
    required String profile,
    required int id,
  }) async {
    var db = await getDB();
    db.update(
      "student",
      {
        "first_name": fn,
        "last_name ": ln,
        "gender ": gender,
        "dob": dob,
        "profile": profile,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
