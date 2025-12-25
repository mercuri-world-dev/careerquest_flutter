part of 'job_search_bloc.dart';

sealed class JobSearchEvent extends Equatable {
  const JobSearchEvent();

  @override
  List<Object> get props => [];
}

final class JobSearchTermChanged extends JobSearchEvent {
  const JobSearchTermChanged(this.query);
  final String query;

  @override
  List<Object> get props => [query];
}

final class JobSearchFiltersChanged extends JobSearchEvent {
  const JobSearchFiltersChanged({this.location, this.remote});
  final String? location;
  final bool? remote;

  @override
  List<Object> get props => [location ?? '', remote ?? false];
}
