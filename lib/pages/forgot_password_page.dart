// ignore_for_file: use_build_context_synchronously

import 'package:dart/extensions/buildcontext/loc.dart';
import 'package:dart/services/auth/bloc/auth_bloc.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/auth/bloc/auth_state.dart';
import 'package:dart/utils/dialogs/password_reset_email_sent_dialog.dart';
import 'package:dart/utils/dialogs/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is! AuthStateForgotPassword) return;

        if (state.hasSentEmail) {
          _controller.clear();
          await showPasswordResetSentDialog(context);
        }

        if (state.exception != null) {
          await showErrorDialog(
            context,
            context.loc.forgot_password_view_generic_error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.forgot_password),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                context.loc.forgot_password_view_prompt,
              ),
              TextField(
                autofocus: true,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: context.loc.email_text_field_placeholder,
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;

                  context.read<AuthBloc>().add(
                        AuthEventForgotPassword(email: email),
                      );
                },
                child: Text(
                  context.loc.forgot_password_view_send_me_link,
                ),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: Text(
                    context.loc.forgot_password_view_back_to_login,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
