import 'package:dart/extensions/buildcontext/loc.dart';
import 'package:dart/utils/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) async {
  return shownGenericDialog(
    context: context,
    title: context.loc.password_reset,
    content: context.loc.password_reset_dialog_prompt,
    optionsBuilder: () => {context.loc.ok: null},
  );
}
