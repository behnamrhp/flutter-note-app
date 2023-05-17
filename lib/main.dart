import 'package:dart/constants/routes.dart';
import 'package:dart/pages/home_page.dart';
import 'package:dart/pages/login_page.dart';
import 'package:dart/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
    routes: {
      loginPage: (context) => const LoginPage(),
      registerPage: (context) => const RegisterPage(),
      homePage: (context) => const HomePage(),
    },
  ));
}

Future<UserCredential?> handleSubmitUser(TextEditingController emailController,
    TextEditingController passwordController,
    {bool isRegister = true}) async {
  final email = emailController.text;
  final password = passwordController.text;
  final userCredentials = isRegister
      ? await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
      : await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
  print(userCredentials);
  return userCredentials;
}
