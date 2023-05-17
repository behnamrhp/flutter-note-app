import 'package:dart/constants/routes.dart';
import 'package:dart/pages/home_page.dart';
import 'package:dart/services/auth/auth_exception.dart';
import 'package:dart/services/auth/auth_service.dart';
import 'package:dart/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dart/utils/user_auth.dart';

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
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null) {
              return const HomePage();
            }
            return Scaffold(
                appBar: AppBar(title: const Text('Login')),
                body: Column(children: [
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
                        await handleSubmitUser(_email, _password,
                            isRegister: false);

                        final user = AuthService.firebase().currentUser;
                        if (user?.isEmailVerified ?? false) {
                          Navigator.of(context).pushReplacementNamed(homePage);
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute, (route) => false);
                        }
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
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                registerPage, (route) => false)
                          },
                      child: const Text(
                          'haven\'t register yet?! go for registration'))
                ]));
          default:
            return const Text('Loading...');
        }
      },
    );
  }
}
