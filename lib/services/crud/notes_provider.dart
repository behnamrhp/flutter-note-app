import 'package:dart/services/crud/models/model_note.dart';
import 'package:dart/services/crud/models/model_user.dart';

abstract class NotesProvider {
  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  });

  Future<Iterable<DatabaseNote>> getAllNotes();

  Future<DatabaseNote> getNote({required int id});

  Future<int> deleteAllNotes();

  Future<void> deleteNote({required int id});

  Future<DatabaseNote> createNote({required DatabaseUser owner});

  Future<DatabaseUser> getUser({required String email});

  Future<DatabaseUser> createUser({required String email});

  Future<void> deleteUser({required String email});

  Future<void> close();

  Future<void> open();
}
