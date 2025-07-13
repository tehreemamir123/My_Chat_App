
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../data/repository/auth_repository.dart';
import '../../../data/services/service_locator.dart';
import '../auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authStateSubscription;

  AuthCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthState()) {
    _init();
  }

  void _init() {
    emit(state.copyWith(status: AuthStatus.initial));

    _authStateSubscription =
        _authRepository.authStateChanges.listen((user) async {
          if (user != null) {
            try {
              final userData = await _authRepository.getUserData(user.uid);
              emit(state.copyWith(
                status: AuthStatus.authenticated,
                user: userData,
              ));
            } catch (e) {
              emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
            }
          } else {
            emit(state.copyWith(
              status: AuthStatus.unauthenticated,
              user: null,
            ));
          }
        });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String username,
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));

      final user = await _authRepository.signUp(
          fullName: fullName,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          password: password);

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      print(getIt<AuthRepository>().currentUser?.uid ?? "asasa");
      await _authRepository.singOut();
      print(getIt<AuthRepository>().currentUser?.uid ?? "asasa");
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, error: e.toString()));
    }
  }
}
