import 'package:dart/services/crud/models/model_note.dart';
import 'package:dart/services/crud/models/model_user.dart';
import 'package:dart/services/crud/notes_exceptions.dart';
import 'package:dart/services/crud/notes_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

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

    final dbUser = await getUser(email: owner.email);

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
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    // get check user exists
    final isUserExists = await db.query(userTable,
        limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (isUserExists.isNotEmpty) {
      throw UserAlreadyExists();
    }
    // insert new user
    final newUserId = await db.insert(userTable, {
      emailColumn: email,
    });
    // return user database
    return DatabaseUser(id: newUserId, email: email);
  }

  @override
  Future<int> deleteAllNotes() async {
    // get db
    final db = _getDatabaseOrThrow();
    // delete notes all rows
    return await db.delete(userTable);
  }

  @override
  Future<void> deleteNote({required int id}) async {
    // get db
    final db = _getDatabaseOrThrow();
    // delete node
    final deletedCount =
        await db.delete(noteTable, where: 'id = ?', whereArgs: [id]);
    // check note deleted
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  @override
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (deletedCount == 0) {
      throw CouldNotDeleteUser();
    }
  }

  @override
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();

    final notes = await db.query(noteTable);

    return notes.map((note) => DatabaseNote.fromRow(note));
  }

  @override
  Future<DatabaseNote> getNote({required int id}) async {
    // get db
    final db = _getDatabaseOrThrow();
    // get note
    final note = await db.query(noteTable, where: 'id = ?', whereArgs: [id]);
    // check exists
    if (note.isEmpty) {
      throw CouldNotFindNote();
    }
    // return note model
    return DatabaseNote.fromRow(note.first);
  }

  @override
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final user = await db
        .query(userTable, where: 'email = ?', whereArgs: [email.toLowerCase()]);

    if (user.isEmpty) {
      throw CouldNotFindUser();
    }

    return DatabaseUser.fromRow(user.first);
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

  Future<void> createTable(String sqlCode) async {
    final db = _getDatabaseOrThrow();

    await db.execute(sqlCode);
  }

  @override
  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    // get db
    final db = _getDatabaseOrThrow();
    // get note and check exists
    await getNote(id: note.id);
    // update
    final updatesCount = await db.update(
      noteTable,
      where: 'id = ?',
      whereArgs: [note.id],
      {textColumnName: text, isSyncedWithCloudColumnName: 0},
    );

    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    }
    // return new model
    return await getNote(id: note.id);
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
