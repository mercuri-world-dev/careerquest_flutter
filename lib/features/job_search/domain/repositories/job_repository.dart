import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';

abstract interface class JobRepository {
  Future<List<Job>> searchJobs({
    required String query,
    String? location,
    bool? remote,
    int? limit,
  });
}
