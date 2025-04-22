import 'package:app/core/utils/logger.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/domain/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  Future<User?> build() async => null;

  Future<User?> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider.notifier);
      final user = await repository.login(email, password);
      return user;
    });
    return state.value;
  }

  Future<User?> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider.notifier);
      final user = await repository.register(email, password, name);
      return user;
    });
    return state.value;
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    await ref.read(authRepositoryProvider.notifier).logout();
    state = const AsyncValue.data(null);
  }
}
