import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';

abstract interface class JobRepository {
  Future<List<Job>> searchJobs({
    required String query,
    String? location,
    bool? remote,
    String? jobType,
    String? experienceLevel,
    double? minSalary,
    double? maxSalary,
    String? industry,
    String? sortBy,
    int? limit,
  });
}
