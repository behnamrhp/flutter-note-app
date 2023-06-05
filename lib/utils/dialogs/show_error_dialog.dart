import 'package:dart/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String message) {
  return shownGenericDialog(
      context: context,
      title: 'Error',
      content: message,
      optionsBuilder: () => {
            'OK': null,
          });
}
