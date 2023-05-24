import 'package:dart/services/crud/models/model_note.dart';
import 'package:dart/services/crud/models/model_user.dart';
import 'package:dart/services/crud/notes_exceptions.dart';
import 'package:dart/services/crud/notes_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path_provider/path_provider.dart';

///
///@todo: should be completed based on this git codes
@immutable
class NotesService implements NotesProvider {
  Database? _db;

  final List<String> _tablesSqlCodeList = [
    createUserTable,
    createNoteTable,
  ];

  Database _getDatabaseOrThrow() {
    final db = _db;

    if (db == null) throw DatabaseIsNotOpen();

    return db;
  }

  @override
  Future<void> close() async {
    final db = _getDatabaseOrThrow();

    await db.close();
    _db = null;
  }

  @override
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    final dbUser = getUser(email: owner.email);

    if (dbUser != owner) throw CouldNotFindUser();

    const text = '';

    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumnName: text,
      isSyncedWithCloudColumnName: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    return note;
  }

  @override
  Future createUser({required String email}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<int> deleteAllNotes() {
    // TODO: implement deleteAllNotes
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNote({required int id}) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser({required String email}) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<Iterable<DatabaseNote>> getAllNotes() {
    // TODO: implement getAllNotes
    throw UnimplementedError();
  }

  @override
  Future<DatabaseNote> getNote({required int id}) {
    // TODO: implement getNote
    throw UnimplementedError();
  }

  @override
  Future getUser({required String email}) async {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> open() async {
    if (_db != null) throw DatabaseAlreadyOpenException();
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      _tablesSqlCodeList.map((sqlCode) async {
        await createTable(sqlCode);
      });
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> createTable(String SqlCode) async {
    final db = _getDatabaseOrThrow();

    await db.execute(SqlCode);
  }

  @override
  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}

const dbName = 'notes_db';
const noteTable = 'note';
const userTable = 'user';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "$userTable" (
        "id"	INTEGER NOT NULL,
        "email"	TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "$noteTable" (
        "id"	INTEGER NOT NULL,
        "user_id"	INTEGER NOT NULL,
        "text"	TEXT,
        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("user_id") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
