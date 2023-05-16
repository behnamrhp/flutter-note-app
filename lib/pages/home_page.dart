import 'package:dart/firebase_options.dart';
import 'package:dart/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        final user = FirebaseAuth.instance.currentUser;
        print(user);
        if (user?.emailVerified == true) {
          print('Your are verified');
        } else {
          print('You need to verify your email');
        }

        if (user != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Home page')),
            body: Column(
              children: [
                Text('you are entered to the app, your email is ${user.email}'),
                TextButton(
                    onPressed: () => {FirebaseAuth.instance.signOut()},
                    child: const Text('Logout!'))
              ],
            ),
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
