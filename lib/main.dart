import 'package:dart/constants/routes.dart';
import 'package:dart/pages/home_page.dart';
import 'package:dart/pages/login_page.dart';
import 'package:dart/pages/notes/create_update_note_page.dart';
import 'package:dart/pages/register.dart';
import 'package:dart/pages/verify_email.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
    routes: {
      loginPage: (context) => const LoginPage(),
      registerPage: (context) => const RegisterPage(),
      homePage: (context) => const HomePage(),
      verifyEmailRoute: (context) => const VerifyEmailPage(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteViewPage(),
    },
  ));
}
