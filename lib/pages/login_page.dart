import 'package:dart/extensions/buildcontext/loc.dart';
import 'package:dart/services/auth/auth_exception.dart';
import 'package:dart/services/auth/bloc/auth_bloc.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/auth/bloc/auth_state.dart';
import 'package:dart/utils/dialogs/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is! AuthStateLoggedOut) return;

        if (state.exception is UserNotFoundAuthException) {
          await showErrorDialog(
            context,
            context.loc.login_error_cannot_find_user,
          );
        } else if (state.exception is UserNotFoundAuthException) {
          await showErrorDialog(
            context,
            context.loc.login_error_cannot_find_user,
          );
        } else if (state.exception is WrongPasswordAuthException) {
          await showErrorDialog(
            context,
            context.loc.login_error_wrong_credentials,
          );
        } else if (state.exception is GenericAuthException) {
          await showErrorDialog(
            context,
            context.loc.login_error_auth_error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.login)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(context.loc.login_view_prompt),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: context.loc.email_text_field_placeholder),
              ),
              TextField(
                controller: _password,
                autocorrect: false,
                obscureText: true,
                enableSuggestions: false,
                decoration: InputDecoration(
                    hintText: context.loc.password_text_field_placeholder),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                },
                child: Text(context.loc.login),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventForgotPassword());
                },
                child: Text(
                  context.loc.login_view_forgot_password,
                ),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                  child: Text(
                    context.loc.login_view_not_registered_yet,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
