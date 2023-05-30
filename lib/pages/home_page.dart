import 'package:dart/pages/login_page.dart';
import 'package:dart/pages/notes/notes_view.dart';
import 'package:dart/pages/verify_email.dart';
import 'package:dart/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        final user = AuthService.firebase().currentUser;
        if (user != null) {
          if (user.isEmailVerified == true) {
            return const NotesView();
          } else {
            return const VerifyEmailPage();
          }
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
