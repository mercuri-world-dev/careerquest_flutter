import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:careerquest_flutter/features/authentication/domain/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

@injectable
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
    return emit.onEach<AuthenticationStatus>(
      _authenticationRepository.status,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            emit(const AuthenticationState.unauthenticated());
            break;
          case AuthenticationStatus.authenticated:
            final user = _authenticationRepository.getSignedInUser();
            if (user != null) {
              emit(AuthenticationState.authenticated(user));
            } else {
              try {
                final user = await _authenticationRepository
                    .getCurrentUser()
                    .firstWhere((user) => user != null)
                    .timeout(const Duration(seconds: 5));
                if (user != null) {
                  emit(AuthenticationState.authenticated(user));
                } else {
                  emit(const AuthenticationState.unauthenticated());
                }
              } catch (_) {
                emit(const AuthenticationState.unauthenticated());
              }
            }
            break;
          case AuthenticationStatus.unknown:
            emit(const AuthenticationState.unknown());
            break;
        }
      },
      onError: addError,
    );
  }

  Future<void> _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.signOut();
  }
}
