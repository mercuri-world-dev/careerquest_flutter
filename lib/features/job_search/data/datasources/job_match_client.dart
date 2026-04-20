import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class JobMatchClient {
  JobMatchClient(this._dio);

  final Dio _dio;

  static const String _baseUrl = String.fromEnvironment(
    'JOB_MATCH_API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8080',
  );

  /// Calls the backend /compatibility endpoint.
  Future<List<double>> getCompatibility({
    required String userProfile,
    required List<String> jobTexts,
    String method = 'tfidf',
  }) async {
    try {
      final body = {
        'user_profile': userProfile,
        'jobs': jobTexts,
        'method': method,
      };

      final response = await _dio.post<dynamic>('$_baseUrl/compatibility', data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map && data.containsKey('scores')) {
          final raw = data['scores'];
          if (raw is List) {
            return raw.map<double>((e) => (e as num).toDouble()).toList();
          }
        }
        // Fallback: try to parse as list
        if (data is List) {
          return data.map<double>((e) => (e as num).toDouble()).toList();
        }
        throw Exception('Unexpected response format from compatibility API');
      } else {
        throw Exception('Compatibility API error: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error while fetching compatibility: ${e.message}');
    }
  }
}
