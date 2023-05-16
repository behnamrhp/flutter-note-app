import 'package:dart/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
  ));
}

Future<UserCredential?> handleSubmitUser(TextEditingController emailController,
    TextEditingController passwordController,
    {bool isRegister = true}) async {
  try {
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
    return userCredentials;
  } catch (error) {
    print('_______________error is _________');
    print(error);
  }
  return null;
}
