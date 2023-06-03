import 'package:dart/constants/routes.dart';
import 'package:dart/services/auth/auth_exception.dart';
import 'package:dart/services/auth/bloc/auth_bloc.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
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
    return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Column(children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            obscureText: true,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;

                context.read<AuthBloc>().add(AuthEventLogIn(email, password));
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong credentials',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () => {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(registerPage, (route) => false)
                  },
              child: const Text('haven\'t register yet?! go for registration'))
        ]));
  }
}
