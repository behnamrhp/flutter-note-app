import 'package:bloc/bloc.dart';
import 'package:dart/services/auth/auth_provider.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider) : super(const AuthStateUninitialized()) {
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
        emit(const AuthStateNeedsVerification());
      } on Exception catch (e) {
        emit(AuthStateRegistering(e));
      }
    });
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
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
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
          emit(const AuthStateNeedsVerification());
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(null));
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
