import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/utils/app_config.dart';
import 'package:proactive_expense_manager/core/utils/shared_perferences.dart';

class AuthRepository {
  final Dio dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

  AuthRepository() {
    _addToken();
  }

  void _addToken() async {
    final prefs = SharedPreferencesDataProvider();
    String token = await prefs.getAccessToken();

    if (token.isNotEmpty) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
  }


  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await dio.post(
        "/auth/send-otp/",
        data: {"phone": "+91$phone"},
      );
      print(response);
      return response.data;
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
       print(response);
      return response.data;
    } catch (e) {
      print("createAccount error: $e");
      return {};
    }
  }


}