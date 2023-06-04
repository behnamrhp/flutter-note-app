import 'package:dart/utils/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) async {
  return shownGenericDialog(
    context: context,
    title: 'Password Reset',
    content:
        'We have now sent you a password reset link. Please check your email for more information.',
    optionsBuilder: () => {'OK': null},
  );
}
