part of 'job_compatibility_bloc.dart';

abstract class JobCompatibilityEvent {}

class FetchCompatibility extends JobCompatibilityEvent {
  FetchCompatibility({required this.userProfile, required this.jobs});

  final String userProfile;
  final List<Job> jobs;
}
