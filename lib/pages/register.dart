import 'package:dart/constants/routes.dart';
import 'package:dart/services/auth/auth_exception.dart';
import 'package:dart/services/auth/auth_service.dart';
import 'package:dart/utils/show_error_dialog.dart';
import 'package:dart/utils/user_auth.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(children: [
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(hintText: 'Enter your email'),
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
                    try {
                      handleSubmitUser(_email, _password);
                      AuthService.firebase().sendEmailVerification();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute, (_) => false);
                      }
                    } on WeakPasswordAuthException {
                      await showErrorDialog(
                        context,
                        'Weak password',
                      );
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(
                        context,
                        'Email is already in use',
                      );
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        'This is an invalid email address',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        'Failed to register',
                      );
                    }
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                    onPressed: () => {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              loginPage, (route) => false)
                        },
                    child: const Text('already have an account?!'))
              ]);
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
