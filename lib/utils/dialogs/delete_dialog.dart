import 'package:dart/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return shownGenericDialog<bool>(
      context: context,
      title: 'Delete Note',
      content: 'Are you sure you want to delete this note?',
      optionsBuilder: () => {
            'Cancel': false,
            'Yes': true,
          }).then((value) => value ?? false);
}
