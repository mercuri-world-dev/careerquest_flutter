import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/features/job_search/data/datasources/job_match_client.dart';
import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';
import 'package:careerquest_flutter/features/job_search/domain/repositories/compatibility_repository.dart';
import 'package:injectable/injectable.dart';

@production
@staging
@LazySingleton(as: CompatibilityRepository)
class CompatibilityRepositoryImpl implements CompatibilityRepository {
  CompatibilityRepositoryImpl(this._client);

  final JobMatchClient _client;

  @override
  Future<List<double>> getCompatibility({required String userProfile, required List<Job> jobs, String? method}) async {
    // Convert jobs to a list of textual descriptions. Prefer description if available.
    final jobTexts = jobs.map((j) => j.description ?? '${j.roleName} at ${j.companyName}').toList();
    final scores = await _client.getCompatibility(userProfile: userProfile, jobTexts: jobTexts, method: method ?? 'tfidf');
    return scores;
  }
}
