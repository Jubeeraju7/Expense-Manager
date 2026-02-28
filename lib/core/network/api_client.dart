import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/utils/app_config.dart';
import 'package:proactive_expense_manager/core/utils/shared_perferences.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SharedPreferencesDataProvider().getAccessToken();
          print("the token$token");
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            // Token expired or invalid
            print("Unauthorized - Token may be expired");
          }
          return handler.next(error);
        },
      ),
    );
  }
}
