import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart/services/cloud/cloud_note.dart';
import 'package:dart/services/cloud/cloud_storage_constants.dart';
import 'package:dart/services/cloud/cloud_storage_exceptions.dart';
import 'package:dart/services/crud/notes_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection(notesCollectionName);

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNote();
    }
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
              (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNote({required ownerUserId}) async {
    try {
      final newDocument = await notes
          .add({ownerUserIdFieldName: ownerUserId, textFieldName: ''});

      final fetchedNote = await newDocument.get();

      return CloudNote(
          documentId: fetchedNote.id, ownerUserId: ownerUserId, text: '');
    } catch (e) {
      throw CouldNotCreateNoteException();
    }
  }
}
