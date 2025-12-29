import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';
import 'package:careerquest_flutter/features/job_search/domain/repositories/job_repository.dart';
import 'package:injectable/injectable.dart';

@staging
@development
@LazySingleton(as: JobRepository)
class MockJobRepository implements JobRepository {
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
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final allJobs = [
      const Job(
        id: 1,
        providedId: 'job-1',
        provider: 'LinkedIn',
        companyName: 'TechCorp',
        roleName: 'Software Engineer',
        companyProfileId: 101,
        location: 'Remote',
        isRemote: true,
        description: 'Exciting software engineering role.',
        jobType: 'Full-time',
      ),
      const Job(
        id: 2,
        providedId: 'job-2',
        provider: 'Indeed',
        companyName: 'HealthPlus',
        roleName: 'Data Scientist',
        companyProfileId: 102,
        location: 'New York, NY',
        isRemote: false,
        description: 'Analyze healthcare data.',
        jobType: 'Contract',
      ),
      const Job(
        id: 3,
        providedId: 'job-3',
        provider: 'Glassdoor',
        companyName: 'GreenEnergy',
        roleName: 'Product Manager',
        companyProfileId: 103,
        location: 'San Francisco, CA',
        isRemote: true,
        description: 'Lead green energy products.',
        jobType: 'Full-time',
      ),
    ];

    var results = allJobs;

    if (query.isNotEmpty) {
      results = results
          .where(
            (job) =>
                job.roleName.toLowerCase().contains(query.toLowerCase()) ||
                job.companyName.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    if (location != null && location.isNotEmpty) {
      results = results
          .where(
            (j) =>
                j.location != null &&
                j.location!.toLowerCase().contains(location.toLowerCase()),
          )
          .toList();
    }

    if (remote != null) {
      results = results.where((j) => j.isRemote == remote).toList();
    }

    if (jobType != null && jobType.isNotEmpty) {
      results = results
          .where(
            (j) =>
                j.jobType != null &&
                j.jobType!.toLowerCase() == jobType.toLowerCase(),
          )
          .toList();
    }

    if (industry != null && industry.isNotEmpty) {
      results = results
          .where(
            (j) =>
                j.industry != null &&
                j.industry!.toLowerCase().contains(industry.toLowerCase()),
          )
          .toList();
    }

    // minSalary/maxSalary filtering not implemented in mock (no salary data)

    return results;
  }
}
