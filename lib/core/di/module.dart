import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class ThirdPartyModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  GoTrueClient get supabaseAuth => Supabase.instance.client.auth;
}
