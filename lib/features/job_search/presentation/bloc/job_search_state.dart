part of 'job_search_bloc.dart';

enum JobSearchStatus { initial, loading, success, failure }

final class JobSearchState extends Equatable {
  const JobSearchState({
    this.status = JobSearchStatus.initial,
    this.jobs = const [],
    this.query = '',
    this.location,
    this.isRemote = false,
  });

  final JobSearchStatus status;
  final List<Job> jobs;
  final String query;
  final String? location;
  final bool isRemote;

  JobSearchState copyWith({
    JobSearchStatus? status,
    List<Job>? jobs,
    String? query,
    String? location,
    bool? isRemote,
  }) {
    return JobSearchState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      query: query ?? this.query,
      location: location ?? this.location,
      isRemote: isRemote ?? this.isRemote,
    );
  }

  @override
  List<Object?> get props => [status, jobs, query, location, isRemote];
}
