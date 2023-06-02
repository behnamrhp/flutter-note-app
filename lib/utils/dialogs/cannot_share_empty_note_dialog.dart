import 'package:dart/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) async {
  return shownGenericDialog(
      context: context,
      title: 'Sharing',
      content: 'You cannot share an empty note',
      optionsBuilder: () => {'OK': null});
}
