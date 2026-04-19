import 'package:careerquest_flutter/features/job_search/data/models/job_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class JobSpyClient {
  JobSpyClient(this._dio);

  final Dio _dio;

  /// Pass at build/run time, e.g.
  /// `--dart-define=JOB_SEARCH_API_BASE_URL=http://10.0.2.2:8000/api` (Android emulator).
  static const String _baseUrl = String.fromEnvironment(
    'JOB_SEARCH_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000/api',
  );

  Future<List<JobModel>> searchJobs(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post<dynamic>(
        "$_baseUrl/jobs/search",
        data: body,
      );

      if (response.statusCode == 200) {
        final dynamic rawData = response.data;
        List<dynamic> data;

        if (rawData is List) {
          data = rawData;
        } else if (rawData is Map && rawData.containsKey('jobs')) {
          final jobs = rawData['jobs'];
          data = jobs is List<dynamic> ? jobs : <dynamic>[];
        } else {
          data = [];
        }

        return data
            .whereType<Map>()
            .map((m) => JobModel.fromJson(Map<String, dynamic>.from(m)))
            .toList();
      } else {
        throw Exception('Failed to load jobs: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error while fetching jobs: ${e.message}');
    }
  }
}
