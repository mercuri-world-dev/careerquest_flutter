part of 'job_compatibility_bloc.dart';

enum JobCompatibilityStatus { initial, loading, success, failure }

final class JobCompatibilityState extends Equatable {
  const JobCompatibilityState({
    this.status = JobCompatibilityStatus.initial,
    this.scores = const {},
  });

  final JobCompatibilityStatus status;
  final Map<int,double> scores; // jobId -> score

  JobCompatibilityState copyWith({JobCompatibilityStatus? status, Map<int,double>? scores}) {
    return JobCompatibilityState(
      status: status ?? this.status,
      scores: scores ?? this.scores,
    );
  }

  @override
  List<Object?> get props => [status, scores];
}
