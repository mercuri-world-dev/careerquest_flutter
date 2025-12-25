import 'package:careerquest_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.userId,
    required super.ageRange,
    super.hoursPerWeek,
    super.location,
    super.accommodations,
    super.educationalBackground,
    super.remotePreference,
    super.hybridPreference,
    super.inPersonPreference,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
