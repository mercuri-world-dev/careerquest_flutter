import 'package:careerquest_flutter/features/job_search/data/datasources/job_spy_client.dart';
import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';
import 'package:careerquest_flutter/features/job_search/domain/repositories/job_repository.dart';
import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:injectable/injectable.dart';

@production
@staging
@LazySingleton(as: JobRepository)
class JobRepositoryImpl implements JobRepository {
  JobRepositoryImpl(this._client);

  final JobSpyClient _client;

  @override
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
  }) async {
    try {
      final jobs = await _client.searchJobs({
        'query': query,
        'location': location,
        'remote': remote,
        'job_type': jobType,
        'experience_level': experienceLevel,
        'min_salary': minSalary,
        'max_salary': maxSalary,
        'industry': industry,
        'sort_by': sortBy,
        'limit': limit,
      });
      return jobs;
    } catch (e) {
      // Return empty list on error for now, or rethrow custom exception
      throw Exception('Failed to fetch jobs: $e');
    }
  }
}
