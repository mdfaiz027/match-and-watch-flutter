import 'package:dio/dio.dart';
import 'api_client.dart';
import '../constants/app_endpoints.dart';

class ReqresService {
  final ApiClient _apiClient;

  ReqresService(this._apiClient);

  Future<Response> getUsers({int page = 1, bool silent = false}) async {
    return _apiClient.dio.get(
      AppEndpoints.reqresUsersUrl,
      queryParameters: {'page': page},
      options: Options(
        headers: {'x-api-key': AppEndpoints.reqresApiKey},
        extra: {'silent': silent},
      ),
    );
  }

  Future<Response> createUser({
    required String fullName,
    required String movieTaste,
  }) async {
    return _apiClient.dio.post(
      AppEndpoints.reqresUsersUrl,
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
