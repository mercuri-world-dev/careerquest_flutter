import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

const development = Environment('development');
const production = Environment('production');
const staging = Environment('staging');

@injectableInit
Future<void> configureDependencies({String? environment}) async =>
    getIt.init(environment: environment);
