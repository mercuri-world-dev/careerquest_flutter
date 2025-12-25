import 'package:bloc/bloc.dart';
import 'package:careerquest_flutter/features/authentication/domain/authentication_repository.dart';
import 'package:careerquest_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:careerquest_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required ProfileRepository profileRepository,
    required AuthenticationRepository authenticationRepository,
  }) : _profileRepository = profileRepository,
       _authenticationRepository = authenticationRepository,
       super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileUpdateRequested>(_onUpdateRequested);
  }

  final ProfileRepository _profileRepository;
  final AuthenticationRepository _authenticationRepository;

  Future<void> _onStarted(
    ProfileStarted event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = _authenticationRepository.getSignedInUser();
      if (user == null) {
        emit(state.copyWith(status: ProfileStatus.failure));
        return;
      }
      final profile = await _profileRepository.getUserProfile(user.id);
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: profile,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _profileRepository.updateUserProfile(event.profile);
      emit(
        state.copyWith(
          status: ProfileStatus.success,
          profile: event.profile,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }
}
