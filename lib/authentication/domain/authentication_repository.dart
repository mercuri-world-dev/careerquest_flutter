import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

abstract interface class AuthenticationRepository {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Stream<User?> getCurrentUser();
  User? getSignedInUser();
  Stream<AuthenticationStatus> get status;
}
