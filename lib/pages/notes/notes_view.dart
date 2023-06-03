// ignore_for_file: use_build_context_synchronously

import 'package:dart/constants/routes.dart';
import 'package:dart/pages/notes/notes_list_vew.dart';
import 'package:dart/services/auth/auth_service.dart';
import 'package:dart/services/auth/bloc/auth_bloc.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/cloud/cloud_note.dart';
import 'package:dart/services/cloud/firebase_cloud_storage.dart';
import 'package:dart/utils/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuActions {
  logout,
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get useId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case MenuActions.logout:
                  final isLogoutSelected = await showLogoutDialog(context);
                  if (isLogoutSelected) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuActions>(
                  value: MenuActions.logout,
                  child: Text('log out'),
                )
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: useId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final allNotes = snapshot.data as Iterable<CloudNote>;
              onDeleteNote(CloudNote note) async {
                await _notesService.deleteNote(documentId: note.documentId);
              }

              onTapNote(CloudNote note) {
                Navigator.of(context)
                    .pushNamed(createOrUpdateNoteRoute, arguments: note);
              }
              return NotesListView(
                notes: allNotes,
                onDeleteNote: onDeleteNote,
                onTap: onTapNote,
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
