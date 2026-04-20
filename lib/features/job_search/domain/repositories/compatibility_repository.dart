import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';

abstract interface class CompatibilityRepository {
  /// Returns a list of scores (0.0 - 1.0) aligned with [jobs].
  Future<List<double>> getCompatibility({
    required String userProfile,
    required List<Job> jobs,
    String? method,
  });
}
