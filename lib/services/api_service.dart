import '../models/user_model.dart';

class ApiService {
  // Fake login service
  static Future<User?> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // delay for demo
    if (username == "admin" && password == "1234") {
      return User(username: "Admin", email: "admin@example.com");
    }
    return null; // invalid login
  }
}
