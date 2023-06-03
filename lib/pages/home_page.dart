import 'package:dart/pages/login_page.dart';
import 'package:dart/pages/notes/notes_view.dart';
import 'package:dart/pages/verify_email.dart';
import 'package:dart/services/auth/bloc/auth_bloc.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      print('-----------');
      print(state);
      if (state is AuthStateLoggedIn) {
        return const NotesView();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailPage();
      } else if (state is AuthStateLoggedOut) {
        return const LoginPage();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
