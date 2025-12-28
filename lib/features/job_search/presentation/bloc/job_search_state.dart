part of 'job_search_bloc.dart';

enum JobSearchStatus { initial, loading, success, failure }

final class JobSearchState extends Equatable {
  const JobSearchState({
    this.status = JobSearchStatus.initial,
    this.jobs = const [],
    this.query = '',
    this.location,
    this.isRemote = false,
    this.jobType,
    this.experienceLevel,
    this.minSalary,
    this.maxSalary,
    this.industry,
    this.sortBy,
  });

  final JobSearchStatus status;
  final List<Job> jobs;
  final String query;
  final String? location;
  final bool isRemote;
  final String? jobType;
  final String? experienceLevel;
  final double? minSalary;
  final double? maxSalary;
  final String? industry;
  final String? sortBy;

  JobSearchState copyWith({
    JobSearchStatus? status,
    List<Job>? jobs,
    String? query,
    String? location,
    bool? isRemote,
    String? jobType,
    String? experienceLevel,
    double? minSalary,
    double? maxSalary,
    String? industry,
    String? sortBy,
  }) {
    return JobSearchState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      query: query ?? this.query,
      location: location ?? this.location,
      isRemote: isRemote ?? this.isRemote,
      jobType: jobType ?? this.jobType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      industry: industry ?? this.industry,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [
    status,
    jobs,
    query,
    location,
    isRemote,
    jobType,
    experienceLevel,
    minSalary,
    maxSalary,
    industry,
    sortBy,
  ];
}
