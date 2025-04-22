class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'メールアドレスを入力してください';
    }
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegex.hasMatch(value)) {
      return '有効なメールアドレスを入力してください';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }
    if (value.length < 6) {
      return 'パスワードは6文字以上で入力してください';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '名前を入力してください';
    }
    if (value.length > 50) {
      return '名前は50文字以内で入力してください';
    }
    return null;
  }

  static String? validateNoteTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'タイトルを入力してください';
    }
    if (value.length > 100) {
      return 'タイトルは100文字以内で入力してください';
    }
    return null;
  }

  static String? validateNoteContent(String? value) {
    if (value == null || value.isEmpty) {
      return '内容を入力してください';
    }
    if (value.length > 10000) {
      return '内容は10000文字以内で入力してください';
    }
    return null;
  }
}
