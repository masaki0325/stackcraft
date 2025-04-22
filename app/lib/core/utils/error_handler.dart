import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static String getErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'サーバーとの通信がタイムアウトしました';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['message'] as String?;
          if (statusCode == 400) {
            return message ?? '入力内容が正しくありません';
          } else if (statusCode == 401) {
            return message ?? 'メールアドレスまたはパスワードが正しくありません';
          } else if (statusCode == 403) {
            return 'アクセスが拒否されました';
          } else if (statusCode == 404) {
            return '該当するデータが見つかりません';
          }
          return message ?? 'サーバーエラーが発生しました';
        case DioExceptionType.connectionError:
          return 'インターネット接続を確認してください';
        default:
          return 'エラーが発生しました';
      }
    }
    return 'エラーが発生しました';
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
