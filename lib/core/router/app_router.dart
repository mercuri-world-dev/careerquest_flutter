import 'dart:async';

import 'package:careerquest_flutter/app/view/scaffold_with_navigation.dart';
import 'package:careerquest_flutter/features/authentication/domain/authentication_repository.dart';
import 'package:careerquest_flutter/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:careerquest_flutter/features/authentication/presentation/login/view/login_page.dart';
import 'package:careerquest_flutter/features/home/view/home_page.dart';
import 'package:careerquest_flutter/features/job_search/presentation/view/job_search_page.dart';
import 'package:careerquest_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:careerquest_flutter/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:careerquest_flutter/features/profile/presentation/view/edit_profile_page.dart';
import 'package:careerquest_flutter/features/profile/presentation/view/profile_page.dart';
import 'package:careerquest_flutter/splash/view/splash_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter(this._authenticationBloc);

  final AuthenticationBloc _authenticationBloc;

  late final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: _GoRouterRefreshStream(_authenticationBloc.stream),
    redirect: (context, state) {
      final authState = _authenticationBloc.state;
      final isSplash = state.matchedLocation == '/splash';
      final isLogin = state.matchedLocation == '/login';

      if (authState.status == AuthenticationStatus.unknown) {
        return '/splash';
      }

      if (authState.status == AuthenticationStatus.unauthenticated) {
        if (isLogin) return null;
        return '/login';
      }

      if (authState.status == AuthenticationStatus.authenticated) {
        if (isSplash || isLogin) return '/home';
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/jobs',
                builder: (context, state) => const JobSearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) {
                      final extra = state.extra as Map<String, dynamic>;
                      final profile = extra['profile'] as UserProfile;
                      final bloc = extra['bloc'] as ProfileBloc;
                      return BlocProvider.value(
                        value: bloc,
                        child: EditProfilePage(profile: profile),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
