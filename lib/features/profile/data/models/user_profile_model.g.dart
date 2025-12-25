// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      ageRange: json['age_range'] as String,
      hoursPerWeek: (json['hours_per_week'] as num?)?.toInt(),
      location: json['location'] as String?,
      accommodations: (json['accommodations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      educationalBackground: json['educational_background'] as String?,
      remotePreference: json['remote_preference'] as bool?,
      hybridPreference: json['hybrid_preference'] as bool?,
      inPersonPreference: json['in_person_preference'] as bool?,
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'age_range': instance.ageRange,
      'hours_per_week': instance.hoursPerWeek,
      'location': instance.location,
      'accommodations': instance.accommodations,
      'educational_background': instance.educationalBackground,
      'remote_preference': instance.remotePreference,
      'hybrid_preference': instance.hybridPreference,
      'in_person_preference': instance.inPersonPreference,
    };
