import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;
  //final String _baseUrl = 'https://api.orianosy.com/';

  ApiService(this._dio);

  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.get(
      '$_baseUrl$endpoint',
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response.data;
  }
}
