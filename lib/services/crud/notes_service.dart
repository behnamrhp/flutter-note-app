import 'dart:async';

import 'package:dart/services/crud/models/model_note.dart';
import 'package:dart/services/crud/models/model_user.dart';
import 'package:dart/services/crud/notes_exceptions.dart';
import 'package:dart/services/crud/notes_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class NotesService implements NotesProvider {
  Database? _db;

  List<DatabaseNote> _notes = [];

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController =
        StreamController<List<DatabaseNote>>.broadcast(onListen: () {
      _notesStreamController.sink.add(_notes);
    });
  }

  factory NotesService() => _shared;

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      await _ensureDbIsOpen();
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUser {
      final newUser = await createUser(email: email);
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allnotes = await getAllNotes();

    _notes = allnotes.toList();
    _notesStreamController.add(_notes);
  }

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
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();

    final dbUser = await getUser(email: owner.email);

    if (dbUser != owner) throw CouldNotFindUser();

    const text = '';

    final noteId = await db.insert(noteTable, {
      userIdColumnName: owner.id,
      textColumnName: text,
      isSyncedWithCloudColumnName: 1,
    });

    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );

    _notes.add(note);
    _notesStreamController.add(_notes);
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
    await _ensureDbIsOpen();
    // get db
    final db = _getDatabaseOrThrow();
    // delete notes all rows
    final numberOfDeletions = await db.delete(userTable);

    _notes = [];
    _notesStreamController.add(_notes);

    return numberOfDeletions;
  }

  @override
  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    // get db
    final db = _getDatabaseOrThrow();
    // delete node
    final deletedCount =
        await db.delete(noteTable, where: 'id = ?', whereArgs: [id]);
    // check note deleted
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }

    _notes.removeWhere((note) => note.id == id);
    _notesStreamController.add(_notes);
  }

  @override
  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (deletedCount == 0) {
      throw CouldNotDeleteUser();
    }
  }

  @override
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();

    final notes = await db.query(noteTable);

    return notes.map((note) => DatabaseNote.fromRow(note));
  }

  @override
  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();

    // get db
    final db = _getDatabaseOrThrow();
    // get note
    final notes = await db.query(noteTable, where: 'id = ?', whereArgs: [id]);
    // check exists
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    }
    // return note model
    final note = DatabaseNote.fromRow(notes.first);

    _notes.removeWhere((cachedNote) => cachedNote.id == id);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  @override
  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();

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

      // create the user table
      await db.execute(createUserTable);
      // create note table
      await db.execute(createNoteTable);

      await _cacheNotes();
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
    await _ensureDbIsOpen();
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
    final updatedNote = await getNote(id: note.id);
    _notes.removeWhere((note) => note.id == updatedNote.id);
    _notes.add(updatedNote);
    _notesStreamController.add(_notes);
    return updatedNote;
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
