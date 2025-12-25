import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:careerquest_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@development
@LazySingleton(as: ProfileRepository)
class MockProfileRepository implements ProfileRepository {
  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const UserProfile(
      id: 1,
      userId: 'mock-user-id',
      ageRange: '25-34',
      hoursPerWeek: 40,
      location: 'New York, NY',
      accommodations: ['Remote work', 'Flexible hours'],
      educationalBackground: 'Bachelor of Science in Computer Science',
      remotePreference: true,
      hybridPreference: false,
      inPersonPreference: false,
    );
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}
