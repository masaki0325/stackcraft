import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/constants/api_constants.dart';
import 'dart:developer' as developer;

part 'api_client.g.dart';

@riverpod
Dio apiClient(ApiClientRef ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      contentType: 'application/json',
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  final secureStorage = const FlutterSecureStorage();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        developer.log(
          '🌐 ${options.method} ${options.uri}',
          name: 'API',
          error: 'Body: ${options.data}',
        );
        return handler.next(options);
      },
      onResponse: (response, handler) {
        developer.log(
          '✅ ${response.statusCode} ${response.requestOptions.uri}',
          name: 'API',
          error: 'Response: ${response.data}',
        );
        return handler.next(response);
      },
      onError: (error, handler) {
        developer.log(
          '❌ ${error.response?.statusCode} ${error.requestOptions.uri}',
          name: 'API',
          error: 'Error: ${error.message}\nResponse: ${error.response?.data}',
        );
        if (error.response?.statusCode == 401) {
          secureStorage.delete(key: 'token');
        }
        return handler.next(error);
      },
    ),
  );

  return dio;
}
