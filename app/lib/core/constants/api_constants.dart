class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // Notes endpoints
  static const String notes = '/notes';
  static const String createNote = '/notes/create';
  static const String updateNote = '/notes/update';
  static const String deleteNote = '/notes/delete';
}
