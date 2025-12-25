import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.userId,
    required this.ageRange,
    this.hoursPerWeek,
    this.location,
    this.accommodations,
    this.educationalBackground,
    this.remotePreference,
    this.hybridPreference,
    this.inPersonPreference,
  });

  final int id;
  final String userId;
  final String ageRange;
  final int? hoursPerWeek;
  final String? location;
  final List<String>? accommodations;
  final String? educationalBackground;
  final bool? remotePreference;
  final bool? hybridPreference;
  final bool? inPersonPreference;

  @override
  List<Object?> get props => [
    id,
    userId,
    ageRange,
    hoursPerWeek,
    location,
    accommodations,
    educationalBackground,
    remotePreference,
    hybridPreference,
    inPersonPreference,
  ];

  UserProfile copyWith({
    String? ageRange,
    int? hoursPerWeek,
    String? location,
    List<String>? accommodations,
    String? educationalBackground,
    bool? remotePreference,
    bool? hybridPreference,
    bool? inPersonPreference,
  }) {
    return UserProfile(
      id: id,
      userId: userId,
      ageRange: ageRange ?? this.ageRange,
      hoursPerWeek: hoursPerWeek ?? this.hoursPerWeek,
      location: location ?? this.location,
      accommodations: accommodations ?? this.accommodations,
      educationalBackground:
          educationalBackground ?? this.educationalBackground,
      remotePreference: remotePreference ?? this.remotePreference,
      hybridPreference: hybridPreference ?? this.hybridPreference,
      inPersonPreference: inPersonPreference ?? this.inPersonPreference,
    );
  }
}
