// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:careerquest_flutter/core/di/module.dart' as _i517;
import 'package:careerquest_flutter/features/authentication/data/authentication_repository_impl.dart'
    as _i625;
import 'package:careerquest_flutter/features/authentication/data/mock_authentication_repository.dart'
    as _i689;
import 'package:careerquest_flutter/features/authentication/data/user_repository_impl.dart'
    as _i148;
import 'package:careerquest_flutter/features/authentication/domain/authentication_repository.dart'
    as _i213;
import 'package:careerquest_flutter/features/authentication/domain/user_repository.dart'
    as _i252;
import 'package:careerquest_flutter/features/authentication/presentation/bloc/authentication_bloc.dart'
    as _i27;
import 'package:careerquest_flutter/features/authentication/presentation/login/bloc/login_bloc.dart'
    as _i1001;
import 'package:careerquest_flutter/features/job_search/data/datasources/job_spy_client.dart'
    as _i751;
import 'package:careerquest_flutter/features/job_search/data/mock_job_repository.dart'
    as _i546;
import 'package:careerquest_flutter/features/job_search/data/repositories/job_repository_impl.dart'
    as _i165;
import 'package:careerquest_flutter/features/job_search/domain/repositories/job_repository.dart'
    as _i1012;
import 'package:careerquest_flutter/features/job_search/presentation/bloc/job_search_bloc.dart'
    as _i575;
import 'package:careerquest_flutter/features/profile/data/mock_profile_repository.dart'
    as _i728;
import 'package:careerquest_flutter/features/profile/data/repositories/profile_repository_impl.dart'
    as _i495;
import 'package:careerquest_flutter/features/profile/domain/repositories/profile_repository.dart'
    as _i220;
import 'package:careerquest_flutter/features/profile/presentation/bloc/profile_bloc.dart'
    as _i200;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

const String _staging = 'staging';
const String _development = 'development';
const String _production = 'production';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final thirdPartyModule = _$ThirdPartyModule();
    gh.lazySingleton<_i361.Dio>(() => thirdPartyModule.dio);
    gh.lazySingleton<_i454.SupabaseClient>(
      () => thirdPartyModule.supabaseClient,
    );
    gh.lazySingleton<_i454.GoTrueClient>(() => thirdPartyModule.supabaseAuth);
    gh.lazySingleton<_i213.AuthenticationRepository>(
      () => _i689.MockAuthenticationRepository(),
      registerFor: {_staging, _development},
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i213.AuthenticationRepository>(
      () => _i625.AuthenticationRepositoryImpl(gh<_i454.GoTrueClient>()),
      registerFor: {_production},
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i27.AuthenticationBloc>(
      () => _i27.AuthenticationBloc(
        authenticationRepository: gh<_i213.AuthenticationRepository>(),
      ),
    );
    gh.factory<_i1001.LoginBloc>(
      () => _i1001.LoginBloc(
        authenticationRepository: gh<_i213.AuthenticationRepository>(),
      ),
    );
    gh.lazySingleton<_i220.ProfileRepository>(
      () => _i728.MockProfileRepository(),
      registerFor: {_staging, _development},
    );
    gh.lazySingleton<_i751.JobSpyClient>(
      () => _i751.JobSpyClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i252.UserRepository>(() => _i148.UserRepositoryImpl());
    gh.lazySingleton<_i1012.JobRepository>(
      () => _i546.MockJobRepository(),
      registerFor: {_staging, _development},
    );
    gh.lazySingleton<_i1012.JobRepository>(
      () => _i165.JobRepositoryImpl(gh<_i751.JobSpyClient>()),
      registerFor: {_production},
    );
    gh.factory<_i575.JobSearchBloc>(
      () => _i575.JobSearchBloc(jobRepository: gh<_i1012.JobRepository>()),
    );
    gh.lazySingleton<_i220.ProfileRepository>(
      () => _i495.ProfileRepositoryImpl(gh<_i454.SupabaseClient>()),
      registerFor: {_production},
    );
    gh.factory<_i200.ProfileBloc>(
      () => _i200.ProfileBloc(
        profileRepository: gh<_i220.ProfileRepository>(),
        authenticationRepository: gh<_i213.AuthenticationRepository>(),
      ),
    );
    return this;
  }
}

class _$ThirdPartyModule extends _i517.ThirdPartyModule {}
