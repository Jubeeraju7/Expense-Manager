import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/utils/app_config.dart';
import 'package:proactive_expense_manager/core/utils/shared_perferences.dart';

class AuthRepository {
  final Dio dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
  final SharedPreferencesDataProvider prefs = SharedPreferencesDataProvider();

  AuthRepository() {
    _addToken();
  }

  Future<void> _addToken() async {
    String token = await prefs.getAccessToken();

    if (token.isNotEmpty) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
  }

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final body = {"phone": "+91$phone"};

      print("Request Body: $body");

      final response = await dio.post("/auth/send-otp/", data: body);
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      final data = response.data;

      if (data["nickname"] != null) {
        await prefs.saveUserName(data["nickname"]);
      }

      return data;
    } catch (e) {
      print("sendOtp error: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> createAccount({
    required String phone,
    required String nickname,
  }) async {
    try {
      final response = await dio.post(
        "/auth/create-account/",
        data: {"phone": "+91$phone", "nickname": nickname},
      );

      final data = response.data;

      if (data["nickname"] != null) {
        await prefs.saveUserName(data["nickname"]);
      }

      print("createAccount response: $data");
      return data;
    } catch (e) {
      print("createAccount error: $e");
      return {};
    }
  }
}
