import 'package:bloc/bloc.dart';
import 'package:dart/services/auth/auth_provider.dart';
import 'package:dart/services/auth/bloc/auth_event.dart';
import 'package:dart/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider authProvider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>((event, emit) async {
      await authProvider.initialize();
      final user = authProvider.currentUser;

      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    });

    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;

      try {
        final user = await authProvider.login(email: email, password: password);
        print('888888888888888');
        print(email);
        print(password);
        print(user);
        emit(AuthStateLoggedIn(user));
      } on Exception catch (e) {
        emit(AuthStateLoginFailed(e));
      }
    });

    on<AuthEventLogOut>((event, emit) async {
      try {
        await authProvider.logout();
        emit(const AuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AuthStateLoginFailed(e));
      }
    });
  }
}
