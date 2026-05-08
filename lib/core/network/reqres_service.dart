import 'package:dio/dio.dart';
import 'api_client.dart';
import '../constants/app_endpoints.dart';

class ReqresService {
  final ApiClient _apiClient;

  ReqresService(this._apiClient);

  Future<Response> getUsers({int page = 1}) async {
    return _apiClient.dio.get(
      '${AppEndpoints.reqresBaseUrl}${AppEndpoints.reqresUsers}',
      queryParameters: {'page': page},
      options: Options(
        headers: {'x-api-key': AppEndpoints.reqresApiKey},
      ),
    );
  }

  Future<Response> createUser({
    required String fullName,
    required String movieTaste,
  }) async {
    return _apiClient.dio.post(
      '${AppEndpoints.reqresBaseUrl}${AppEndpoints.reqresUsers}',
      data: {
        'name': fullName,
        'job': movieTaste,
      },
      options: Options(
        headers: {'x-api-key': AppEndpoints.reqresApiKey},
      ),
    );
  }
}
