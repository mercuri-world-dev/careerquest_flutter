import 'package:careerquest_flutter/features/authentication/domain/user_repository.dart';
import 'package:injectable/injectable.dart';

// import '../domain/models/models.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {}
