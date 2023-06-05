import 'package:dart/pages/forgot_password_page.dart';
import 'package:dart/pages/login_page.dart';
import 'package:dart/pages/notes/notes_view.dart';
import 'package:dart/pages/register.dart';
import 'package:dart/pages/verify_email.dart';
import 'package:dart/services/auth/bloc/auth_bloc.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/auth/bloc/auth_state.dart';
import 'package:dart/utils/helpers/loading/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          return LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        }
        LoadingScreen().hide();
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailPage();
        } else if (state is AuthStateLoggedOut) {
          return const LoginPage();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordPage();
        } else if (state is AuthStateRegistering) {
          return const RegisterPage();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
