import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';
import 'package:careerquest_flutter/features/job_search/domain/repositories/job_repository.dart';
import 'package:injectable/injectable.dart';

@development
@LazySingleton(as: JobRepository)
class MockJobRepository implements JobRepository {
  @override
  Future<List<Job>> searchJobs({
    required String query,
    String? location,
    bool? remote,
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

    if (query.isEmpty) return allJobs;

    return allJobs
        .where(
          (job) =>
              job.roleName.toLowerCase().contains(query.toLowerCase()) ||
              job.companyName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
