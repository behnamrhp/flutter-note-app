import 'package:dart/constants/routes.dart';
import 'package:dart/pages/home_page.dart';
import 'package:dart/pages/login_page.dart';
import 'package:dart/pages/notes/create_update_note_page.dart';
import 'package:dart/pages/register.dart';
import 'package:dart/pages/verify_email.dart';
import 'package:dart/services/auth/auth_service.dart';
import 'package:dart/services/auth/bloc/auth_bloc.dart';
import 'package:dart/services/auth/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: BlocProvider(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      loginPage: (context) => const LoginPage(),
      registerPage: (context) => const RegisterPage(),
      homePage: (context) => const HomePage(),
      verifyEmailRoute: (context) => const VerifyEmailPage(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteViewPage(),
    },
  ));
}
