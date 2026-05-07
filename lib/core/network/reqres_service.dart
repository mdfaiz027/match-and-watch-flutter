import 'package:dio/dio.dart';
import 'api_client.dart';

class ReqresService {
  final ApiClient _apiClient;
  static const String _baseUrl = 'https://reqres.in/api';

  ReqresService(this._apiClient);

  Future<Response> getUsers({int page = 1}) async {
    return _apiClient.dio.get('$_baseUrl/users', queryParameters: {'page': page});
  }

  Future<Response> createUser({
    required String firstName,
    required String lastName,
    required String movieTaste,
  }) async {
    return _apiClient.dio.post(
      '$_baseUrl/users',
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'job': movieTaste,
      },
    );
  }
}
