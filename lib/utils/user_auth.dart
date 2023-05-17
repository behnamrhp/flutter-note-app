import 'package:dart/services/auth/auth_service.dart';
import 'package:dart/services/auth/auth_user.dart';
import 'package:flutter/material.dart';

Future<AuthUser> handleSubmitUser(TextEditingController emailController,
    TextEditingController passwordController,
    {bool isRegister = true}) async {
  final email = emailController.text;
  final password = passwordController.text;
  final userCredentials = isRegister
      ? await AuthService.firebase()
          .createUser(email: email, password: password)
      : await AuthService.firebase().login(email: email, password: password);
  return userCredentials;
}
