import 'package:dart/extensions/buildcontext/loc.dart';
import 'package:dart/services/auth/auth_exception.dart';
import 'package:dart/services/auth/bloc/auth_bloc.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/auth/bloc/auth_state.dart';
import 'package:dart/utils/dialogs/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        if (state is! AuthStateRegistering) return;

        if (state.exception is WeakPasswordAuthException) {
          await showErrorDialog(
            context,
            context.loc.register_error_weak_password,
          );
        } else if (state.exception is EmailAlreadyInUseAuthException) {
          await showErrorDialog(
            context,
            context.loc.register_error_email_already_in_use,
          );
        } else if (state.exception is InvalidEmailAuthException) {
          await showErrorDialog(
            context,
            context.loc.register_error_generic,
          );
        } else if (state.exception is GenericAuthException) {
          await showErrorDialog(
            context,
            context.loc.register_error_invalid_email,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.register)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(context.loc.register_view_prompt),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: context.loc.email_text_field_placeholder,
                ),
              ),
              TextField(
                controller: _password,
                autocorrect: false,
                obscureText: true,
                enableSuggestions: false,
                decoration: InputDecoration(
                  hintText: context.loc.password_text_field_placeholder,
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventRegister(
                          email,
                          password,
                        ),
                      );
                },
                child: Text(
                  context.loc.register,
                ),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: Text(
                    context.loc.register_view_already_registered,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
