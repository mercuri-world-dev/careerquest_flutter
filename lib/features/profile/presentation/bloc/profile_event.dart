part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

final class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested(this.profile);
  final UserProfile profile;

  @override
  List<Object> get props => [profile];
}
