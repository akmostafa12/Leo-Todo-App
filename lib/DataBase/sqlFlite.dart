import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sql {
  String table;
  int version;

  Sql({required this.table, required this.version});

  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'leo.db');
    Database database = await openDatabase(path,
        onCreate: createDataBase, version: version, onUpgrade: upgradeDataBase);
    return database;
  }

  createDataBase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE "notes" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"title" TEXT NOT NULL,"subtitle" TEXT NOT NULL, "clock" TEXT NOT NULL)');
    version = 1;
  }

  upgradeDataBase(Database db, int oldVersion, int newVersion) async {
    await db.execute(
        'CREATE TABLE "todo" ("id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"title" TEXT NOT NULL,"subtitle" TEXT NOT NULL, "clock" TEXT NOT NULL)');
    oldVersion = 1;
    newVersion = 2;
  }

  insertDatabase(String title, String subtitle, String clock) async {
    Database? mydb = await db;
    int id1 = await mydb!.rawInsert(
      '''
        INSERT INTO "$table" ("title", "subtitle", "clock") VALUES("$title", "$subtitle", "$clock")''',
    );
    return id1;
  }

  Future<List<Map>> getRecords() async {
    Database? mydb = await db;
    List<Map> list = await mydb!.rawQuery("SELECT * FROM $table");
    return list;
  }

  deleteColumn(String id) async {
    Database? mydb = await db;
    int response = await mydb!.delete("$table WHERE id = $id");
    return response;
  }

  deleteDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'leo.db');
    await deleteDatabase(path);
  }
}
