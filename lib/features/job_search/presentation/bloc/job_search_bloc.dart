import 'package:bloc/bloc.dart';
import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';
import 'package:careerquest_flutter/features/job_search/domain/repositories/job_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:injectable/injectable.dart';

part 'job_search_event.dart';
part 'job_search_state.dart';

const _debounceDuration = Duration(milliseconds: 300);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

@injectable
class JobSearchBloc extends Bloc<JobSearchEvent, JobSearchState> {
  JobSearchBloc({required JobRepository jobRepository})
    : _jobRepository = jobRepository,
      super(const JobSearchState()) {
    on<JobSearchStarted>(_onStarted);
    on<JobSearchTermChanged>(
      _onTermChanged,
      transformer: debounce(_debounceDuration),
    );
    on<JobSearchFiltersChanged>(_onFiltersChanged);
    // Dispatch initial load event
    add(const JobSearchStarted());
  }

  Future<void> _onStarted(
    JobSearchStarted event,
    Emitter<JobSearchState> emit,
  ) async {
    emit(state.copyWith(status: JobSearchStatus.loading));
    try {
      final jobs = await _jobRepository.searchJobs(
        query: '',
        location: null,
        remote: null,
        jobType: null,
        experienceLevel: null,
        minSalary: null,
        maxSalary: null,
        industry: null,
        sortBy: null,
      );
      emit(state.copyWith(status: JobSearchStatus.success, jobs: jobs));
    } catch (e) {
      emit(state.copyWith(status: JobSearchStatus.failure));
    }
  }

  final JobRepository _jobRepository;

  Future<void> _onTermChanged(
    JobSearchTermChanged event,
    Emitter<JobSearchState> emit,
  ) async {
    if (event.query.isEmpty) return emit(state.copyWith(query: event.query));

    emit(state.copyWith(query: event.query, status: JobSearchStatus.loading));

    try {
      final jobs = await _jobRepository.searchJobs(
        query: event.query,
        location: state.location,
        remote: state.isRemote,
        jobType: state.jobType,
        experienceLevel: state.experienceLevel,
        minSalary: state.minSalary,
        maxSalary: state.maxSalary,
        industry: state.industry,
        sortBy: state.sortBy,
      );
      emit(
        state.copyWith(
          status: JobSearchStatus.success,
          jobs: jobs,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: JobSearchStatus.failure));
    }
  }

  Future<void> _onFiltersChanged(
    JobSearchFiltersChanged event,
    Emitter<JobSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        location: event.location,
        isRemote: event.remote,
        jobType: event.jobType,
        experienceLevel: event.experienceLevel,
        minSalary: event.minSalary,
        maxSalary: event.maxSalary,
        industry: event.industry,
        sortBy: event.sortBy,
        status: JobSearchStatus.loading,
      ),
    );

    try {
      final jobs = await _jobRepository.searchJobs(
        query: state.query,
        location: state.location,
        remote: state.isRemote,
        jobType: state.jobType,
        experienceLevel: state.experienceLevel,
        minSalary: state.minSalary,
        maxSalary: state.maxSalary,
        industry: state.industry,
        sortBy: state.sortBy,
      );
      emit(
        state.copyWith(
          status: JobSearchStatus.success,
          jobs: jobs,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: JobSearchStatus.failure));
    }
  }
}
