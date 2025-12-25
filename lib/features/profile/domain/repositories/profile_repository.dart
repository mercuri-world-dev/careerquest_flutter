import 'package:careerquest_flutter/features/profile/domain/entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile?> getUserProfile(String userId);
  Future<void> updateUserProfile(UserProfile profile);
}
