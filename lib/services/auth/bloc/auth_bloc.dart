import 'package:bloc/bloc.dart';
import 'package:dart/services/auth/auth_provider.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await authProvider.sendEmailVerification();
      emit(state);
    });

    // register
    on<AuthEventRegister>((event, emit) async {
      try {
        final email = event.email;
        final password = event.password;

        await authProvider.createUser(
          email: email,
          password: password,
        );

        await authProvider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      } on Exception catch (e) {
        emit(
          AuthStateRegistering(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    // forgot password
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: false,
        ));

        final email = event.email;

        if (email == null) {
          return; // just to see the page
        }

        // send email
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSentEmail: false,
          isLoading: true,
        ));

        bool didSendEmail;
        Exception? exception;

        try {
          await authProvider.sendPasswordReste(toEmail: email);
          didSendEmail = true;
        } on Exception catch (e) {
          didSendEmail = false;
          exception = e;
        }

        emit(AuthStateForgotPassword(
          exception: exception,
          hasSentEmail: didSendEmail,
          isLoading: false,
        ));
      },
    );
    // initialize
    on<AuthEventInitialize>((event, emit) async {
      await authProvider.initialize();
      final user = authProvider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    // login
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;

      try {
        final user = await authProvider.login(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(
            AuthStateLoggedIn(
              user: user,
              isLoading: false,
            ),
          );
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(exception: null, isLoading: false));
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await authProvider.logout();
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
