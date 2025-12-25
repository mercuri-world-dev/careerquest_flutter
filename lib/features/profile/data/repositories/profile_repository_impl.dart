import 'package:careerquest_flutter/features/profile/data/models/user_profile_model.dart';
import 'package:careerquest_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:careerquest_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@production
@staging
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return UserProfileModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    final model = UserProfileModel(
      id: profile.id,
      userId: profile.userId,
      ageRange: profile.ageRange,
      hoursPerWeek: profile.hoursPerWeek,
      location: profile.location,
      accommodations: profile.accommodations,
      educationalBackground: profile.educationalBackground,
      remotePreference: profile.remotePreference,
      hybridPreference: profile.hybridPreference,
      inPersonPreference: profile.inPersonPreference,
    );

    await _supabase.from('user_profiles').upsert(model.toJson());
  }
}
