import 'package:dart/firebase_options.dart';
import 'package:dart/main.dart';
import 'package:dart/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        print('we are in builder');
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            print('we are in connection stat of snapshot');
            final user = FirebaseAuth.instance.currentUser;

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
                      final user = await handleSubmitUser(_email, _password,
                          isRegister: false);
                      if (user != null) {
                        Navigator.of(context).pushReplacementNamed('/home/');
                      }
                    },
                    child: const Text('Login'),
                  ),
                  TextButton(
                      onPressed: () => {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/register/', (route) => false)
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
