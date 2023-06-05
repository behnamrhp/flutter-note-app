import 'package:dart/extensions/buildcontext/loc.dart';
import 'package:dart/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String message) {
  return shownGenericDialog(
      context: context,
      title: context.loc.generic_error_prompt,
      content: message,
      optionsBuilder: () => {
            context.loc.ok: null,
          });
}
