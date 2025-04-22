import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/constants/api_constants.dart';
import '../domain/user.dart';
import 'dart:async';
import 'package:app/core/utils/logger.dart';

part 'auth_repository.g.dart';

@riverpod
class AuthRepository extends _$AuthRepository {
  late final Dio _client;
  late final FlutterSecureStorage _secureStorage;

  @override
  Future<User?> build() async {
    _client = ref.read(apiClientProvider);
    _secureStorage = const FlutterSecureStorage();

    // トークンを取得
    final token = await _secureStorage.read(key: 'token');
    if (token != null) {
      _client.options.headers['Authorization'] = 'Bearer $token';
    }
    return null;
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await _client.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];
      await _secureStorage.write(key: 'token', value: token);
      _client.options.headers['Authorization'] = 'Bearer $token';

      return User.fromJson(response.data['user']);
    } catch (e) {
      Logger.error('Failed to login', error: e);
      rethrow;
    }
  }

  Future<User> register(String email, String password, String name) async {
    try {
      final response = await _client.post(
        ApiConstants.register,
        data: {'email': email, 'password': password, 'name': name},
      );

      final token = response.data['token'];
      await _secureStorage.write(key: 'token', value: token);
      _client.options.headers['Authorization'] = 'Bearer $token';

      return User.fromJson(response.data['user']);
    } catch (e) {
      Logger.error('Failed to register', error: e);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // トークンを削除
      await _secureStorage.delete(key: 'token');
      // ヘッダーからも削除
      _client.options.headers.remove('Authorization');
    } catch (e) {
      Logger.error('Failed to logout', error: e);
      rethrow;
    }
  }
}
