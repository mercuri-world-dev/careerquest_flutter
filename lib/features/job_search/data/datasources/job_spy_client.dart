import 'package:careerquest_flutter/features/job_search/data/models/job_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class JobSpyClient {
  JobSpyClient(this._dio);

  final Dio _dio;

  static const String _baseUrl = "https://your-python-backend.com/api";

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
          data = rawData['jobs'] as List<dynamic>;
        } else {
          data = [];
        }

        return data
            .map((json) => JobModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load jobs: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error while fetching jobs: ${e.message}');
    }
  }
}
