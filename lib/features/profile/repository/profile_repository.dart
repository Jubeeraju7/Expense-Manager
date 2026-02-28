import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/network/api_client.dart';
import 'package:proactive_expense_manager/features/home/model/category_model.dart';
import 'package:uuid/uuid.dart';

class ProfileRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<Category>> fetchCategories() async {
    try {
      print("Category API calling...");
      final response = await apiClient.dio.get(
        "/categories/",
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      print("Category API calling..$response");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success') {
          final categories = (data['categories'] as List)
              .map((e) => Category.fromJson(e))
              .toList();
          return categories;
        } else {
          throw Exception(
            "Failed to load categories: ${data['message'] ?? ''}",
          );
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching categories: $e");
      throw Exception("Error fetching categories: $e");
    }
  }

Future<Map<String, dynamic>> addCategory(String name) async {
  try {
    final uuid = const Uuid().v4();

    final body = {
      "categories": [
        {
          "category_id": uuid,
          "name": name,
        }
      ]
    };

    print("REQUEST BODY: $body");

    final response = await apiClient.dio.post(
      "/categories/add/",
      data: body,
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    print("RESPONSE: ${response.data}");

    return response.data;
  } catch (e) {
    if (e is DioException) {
      print("STATUS CODE: ${e.response?.statusCode}");
      print("BACKEND ERROR: ${e.response?.data}");
    }
    return {};
  }
}
  Future<Map<String, dynamic>> deleteCategories(List<String> ids) async {
    try {
      final response = await apiClient.dio.delete(
        "/categories/delete/",
        data: {"ids": ids},
      );
      return response.data;
    } catch (e) {
      print("deleteCategories error: $e");
      return {};
    }
  }
}
