import 'package:dart/extensions/buildcontext/loc.dart';
import 'package:dart/utils/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) async {
  return shownGenericDialog(
      context: context,
      title: context.loc.sharing,
      content: context.loc.cannot_share_empty_note_prompt,
      optionsBuilder: () => {context.loc.ok: null});
}
