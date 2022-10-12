import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

import '../models/todo.dart';
import '../models/user.dart';

class TodoDatabase {
  //Creating a single instance of the database
  static final TodoDatabase instance = TodoDatabase._initialize();
  // this is a link to the database
  static Database? _database;
  TodoDatabase._initialize();

  Future _createDB(Database db, int version) async {
    final userUsernameType = 'TEXT PRIMARY KEY NOT NULL';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

// go to the database and execute sth i.e creating the userTable.
    await db.execute('''CREATE TABLE $userTable(
      ${UserFields.username} $userUsernameType,
      ${UserFields.name} $textType,
      
    )''');

    await db.execute('''CREATE TABLE $todoTable(
      ${TodoFields.username} $textType,
      ${TodoFields.title} $textType,
      ${TodoFields.done} $boolType,
      ${TodoFields.created} $textType,
      FOREIGN KEY (${TodoFields.username}) REFERENCES $userTable (${UserFields.username})
    )''');
// Using the foreign key to show that the username in the todoTable is being refrenced from the userTable.
  }

  // The function below ensures that the foreign key works.
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign keys = ON');
  }

  // Opening the database
  Future<Database> _initDB(String filename) async {
    // for this specific app there is a database path on the phone.
    // this code gets the path to the database where it will be saved on the phone.
    final databasePath = await getDatabasesPath();
    // this path combines the path to your database and filename to give the path where the specific database will reside.
    final path = join(databasePath, filename);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  // Closing the database
  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDB('todo.db');
      return _database;
    }
  }

  // Start of CRUD operations
  Future<User> createUser(User user) async {
    final db = await instance.database;
    await db!.insert(userTable, user.toJson());
    return user;
  }

  Future<User> getUser(String username) async {
    final db = await instance.database;
    final maps = await db!.query(
      userTable,
      columns: UserFields.allFields,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('$username not found in the database');
    }
  }

  // the code below shows how to query the database for multiple users.
  // we won't use this code. It is just practice code.
  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    final result =
        await db!.query(userTable, orderBy: '${UserFields.username} ASC');
    return result.map((e) => User.fromJson(e)).toList();
  }

  // updating a specific record
  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db!.update(
      userTable,
      // the record we are updating is user.toJson()
      user.toJson(),
      where: '${UserFields.username}',
      whereArgs: [user.username],
    );
  }

  Future<Todo> createTodo(Todo todo) async {
    final db = await instance.database;
    await db!.insert(
      todoTable,
      todo.toJson(),
    );
    return todo;
  }

  Future<int> toggleTodoDone(Todo todo) async {
    final db = await instance.database;
    return db!.update(
      todoTable,
      todo.toJson(),
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }
}
