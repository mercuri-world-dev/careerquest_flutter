import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/features/authentication/domain/authentication_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@production
@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(this._supabaseAuth);

  final GoTrueClient _supabaseAuth;
  static final String _redirectUrl = dotenv.get('APP_URL');
  final _statusSubject = BehaviorSubject<AuthenticationStatus>.seeded(
    AuthenticationStatus.unauthenticated,
  );

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _supabaseAuth.signInWithPassword(password: password, email: email);
    _statusSubject.add(AuthenticationStatus.authenticated);
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _supabaseAuth.signUp(
      password: password,
      email: email,
      emailRedirectTo: _redirectUrl,
    );
    _statusSubject.add(AuthenticationStatus.authenticated);
  }

  @override
  Future<void> signOut() async {
    await _supabaseAuth.signOut();
    _statusSubject.add(AuthenticationStatus.unauthenticated);
  }

  @override
  Stream<User?> getCurrentUser() =>
      _supabaseAuth.onAuthStateChange.map((event) => event.session?.user);

  @override
  User? getSignedInUser() => _supabaseAuth.currentUser;

  @override
  Stream<AuthenticationStatus> get status => _statusSubject.asBroadcastStream();

  @override
  @disposeMethod
  void dispose() {
    _statusSubject.close();
  }
}
