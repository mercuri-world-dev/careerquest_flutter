import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/features/authentication/domain/authentication_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@development
@LazySingleton(as: AuthenticationRepository)
class MockAuthenticationRepository implements AuthenticationRepository {
  final _statusSubject = BehaviorSubject<AuthenticationStatus>.seeded(
    AuthenticationStatus.unauthenticated,
  );

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _statusSubject.add(AuthenticationStatus.authenticated);
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _statusSubject.add(AuthenticationStatus.authenticated);
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _statusSubject.add(AuthenticationStatus.unauthenticated);
  }

  @override
  Stream<User?> getCurrentUser() {
    return status.map((s) {
      if (s == AuthenticationStatus.authenticated) {
        return User(
          id: 'mock-user-id',
          appMetadata: {},
          userMetadata: {},
          aud: 'aud',
          createdAt: DateTime.now().toIso8601String(),
        );
      }
      return null;
    });
  }

  @override
  User? getSignedInUser() {
    return _statusSubject.value == AuthenticationStatus.authenticated
        ? User(
            id: 'mock-user-id',
            appMetadata: {},
            userMetadata: {},
            aud: 'aud',
            createdAt: DateTime.now().toIso8601String(),
          )
        : null;
  }

  @override
  Stream<AuthenticationStatus> get status => _statusSubject.asBroadcastStream();

  @override
  @disposeMethod
  void dispose() {
    _statusSubject.close();
  }
}
