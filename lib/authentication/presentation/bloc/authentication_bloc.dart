import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:careerquest_flutter/authentication/domain/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.status,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            return emit(const AuthenticationState.unauthenticated());
          case AuthenticationStatus.authenticated:
            User? user;
            _subscribeUser().listen(
              (e) => user=e,
            );
            return emit(
              user != null
                  ? AuthenticationState.authenticated(user!)
                  : const AuthenticationState.unauthenticated(),
            );
          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  Future<void> _onLogoutPressed (
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.signOut();
  }

  Stream<User?> _subscribeUser() {
    final userStream = _authenticationRepository.getCurrentUser();
    return userStream;
  }
}