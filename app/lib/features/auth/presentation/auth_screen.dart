import 'package:app/core/utils/logger.dart';
import 'package:app/core/utils/validators.dart';
import 'package:app/features/auth/domain/user.dart';
import 'package:app/features/auth/presentation/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:app/core/utils/error_handler.dart';
import 'package:app/features/auth/data/auth_repository.dart';

class AuthScreen extends StatefulHookConsumerWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final nameController = useTextEditingController();
    final isLogin = useState(true);

    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(isLogin.value ? 'ログイン' : '新規登録')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'メールアドレス',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: Validators.validatePassword,
                textInputAction:
                    isLogin.value ? TextInputAction.done : TextInputAction.next,
              ),
              if (!isLogin.value) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '名前',
                    border: OutlineInputBorder(),
                  ),
                  validator: Validators.validateName,
                  textInputAction: TextInputAction.done,
                ),
              ],
              const SizedBox(height: 24),
              if (authState.isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      Logger.info(
                        'フォームのバリデーションが成功しました',
                        details: {
                          'mode': isLogin.value ? 'ログイン' : '新規登録',
                          'email': emailController.text,
                        },
                      );
                      User? user;
                      if (isLogin.value) {
                        try {
                          await ref.read(authRepositoryProvider.notifier).login(
                                emailController.text,
                                passwordController.text,
                              );
                          if (mounted) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.go('/');
                            });
                          }
                        } catch (e) {
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('ログインエラー'),
                                content: Text(ErrorHandler.getErrorMessage(e)),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      } else {
                        try {
                          await ref
                              .read(authRepositoryProvider.notifier)
                              .register(
                                emailController.text,
                                passwordController.text,
                                nameController.text,
                              );
                          if (mounted) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.go('/');
                            });
                          }
                        } catch (e) {
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('登録エラー'),
                                content: Text(ErrorHandler.getErrorMessage(e)),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      }
                    }
                  },
                  child: Text(isLogin.value ? 'ログイン' : '登録'),
                ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  formKey.currentState?.reset();
                  emailController.clear();
                  passwordController.clear();
                  nameController.clear();
                  isLogin.value = !isLogin.value;
                },
                child: Text(isLogin.value ? '新規登録はこちら' : 'ログインはこちら'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
