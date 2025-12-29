part of 'job_search_bloc.dart';

final class JobSearchStarted extends JobSearchEvent {
  const JobSearchStarted();
}

sealed class JobSearchEvent extends Equatable {
  const JobSearchEvent();

  @override
  List<Object?> get props => [];
}

final class JobSearchTermChanged extends JobSearchEvent {
  const JobSearchTermChanged(this.query);
  final String query;

  @override
  List<Object> get props => [query];
}

final class JobSearchFiltersChanged extends JobSearchEvent {
  const JobSearchFiltersChanged({
    this.location,
    this.remote,
    this.jobType,
    this.experienceLevel,
    this.minSalary,
    this.maxSalary,
    this.industry,
    this.sortBy,
  });

  final String? location;
  final bool? remote;
  final String? jobType;
  final String? experienceLevel;
  final double? minSalary;
  final double? maxSalary;
  final String? industry;
  final String? sortBy;

  @override
  List<Object?> get props => [
    location,
    remote,
    jobType,
    experienceLevel,
    minSalary,
    maxSalary,
    industry,
    sortBy,
  ];
}
