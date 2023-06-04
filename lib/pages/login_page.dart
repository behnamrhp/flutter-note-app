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
            'User not found',
          );
        } else if (state.exception is UserNotFoundAuthException) {
          await showErrorDialog(
            context,
            'Cannot find a user with the entered credentials!',
          );
        } else if (state.exception is WrongPasswordAuthException) {
          await showErrorDialog(
            context,
            'Wrong credentials',
          );
        } else if (state.exception is GenericAuthException) {
          await showErrorDialog(
            context,
            'Authentication error',
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'Please log in to your account in order to interact with and create notes!'),
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
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;

                  context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventForgotPassword());
                },
                child: const Text('I forgot my password'),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                  child:
                      const Text('haven\'t register yet?! go for registration'))
            ],
          ),
        ),
      ),
    );
  }
}
