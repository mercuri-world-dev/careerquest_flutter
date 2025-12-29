import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/core/flavor/flavor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
  AppFlavor flavor,
) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Load environment variables for prod/staging
  if (flavor == AppFlavor.production) {
    await dotenv.load();

    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_PUBLISHABLE_KEY'),
    );
  }

  await configureDependencies(environment: flavor.name);

  runApp(await builder());
}
