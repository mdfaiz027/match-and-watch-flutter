import 'package:dio/dio.dart';
import 'api_client.dart';

class ReqresService {
  final ApiClient _apiClient;
  static const String _baseUrl = 'https://reqres.in/api';

  // Replace with your Reqres API Key
  static const String _apiKey = 'free_user_3DQl89b1wFD72BqXyUsTHQE9lGq';

  ReqresService(this._apiClient);

  Future<Response> getUsers({int page = 1}) async {
    return _apiClient.dio.get(
      '$_baseUrl/users',
      queryParameters: {'page': page},
      options: Options(
        headers: {'x-api-key': _apiKey},
      ),
    );
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
      options: Options(
        headers: {'x-api-key': _apiKey},
      ),
    );
  }
}
