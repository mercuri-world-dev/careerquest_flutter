import 'dart:async';

import 'package:careerquest_flutter/authentication/domain/authentication_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl(this._supabaseAuth);

  final GoTrueClient _supabaseAuth;
  static final String _redirectUrl = dotenv.get('APP_URL');
  final _controller = StreamController<AuthenticationStatus>();

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _supabaseAuth.signInWithPassword(password: password, email: email);

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _supabaseAuth.signUp(
          password: password, email: email, emailRedirectTo: _redirectUrl);

  @override
  Future<void> signOut() => _supabaseAuth.signOut();

  @override
  Stream<User?> getCurrentUser() =>
      _supabaseAuth.onAuthStateChange.map((event) => event.session?.user);

  @override
  User? getSignedInUser() => _supabaseAuth.currentUser;

  @override
  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }
}
