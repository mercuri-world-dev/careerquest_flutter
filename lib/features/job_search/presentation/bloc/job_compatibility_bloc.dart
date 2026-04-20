import 'package:bloc/bloc.dart';
import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';
import 'package:careerquest_flutter/features/job_search/domain/repositories/compatibility_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'job_compatibility_event.dart';
part 'job_compatibility_state.dart';

@injectable
class JobCompatibilityBloc extends Bloc<JobCompatibilityEvent, JobCompatibilityState> {
  JobCompatibilityBloc({required CompatibilityRepository repository})
    : _repository = repository,
      super(const JobCompatibilityState()) {
    on<FetchCompatibility>(_onFetch);
  }

  final CompatibilityRepository _repository;

  Future<void> _onFetch(FetchCompatibility event, Emitter<JobCompatibilityState> emit) async {
    if (event.jobs.isEmpty) return;
    emit(state.copyWith(status: JobCompatibilityStatus.loading));
    try {
      final scores = await _repository.getCompatibility(userProfile: event.userProfile, jobs: event.jobs);
      final map = <int,double>{};
      for (var i = 0; i < event.jobs.length && i < scores.length; i++) {
        map[event.jobs[i].id] = scores[i];
      }
      emit(state.copyWith(status: JobCompatibilityStatus.success, scores: map));
    } catch (e) {
      emit(state.copyWith(status: JobCompatibilityStatus.failure));
    }
  }
}
