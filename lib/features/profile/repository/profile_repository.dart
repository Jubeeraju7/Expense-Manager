import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/network/api_client.dart';
import 'package:proactive_expense_manager/features/home/model/category_model.dart';

class ProfileRepository {
  final ApiClient apiClient = ApiClient();

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await apiClient.dio.get("/categories/");

      print("Status code: ${response.statusCode}");
      print("Response : ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'success') {
          final categories = (data['categories'] as List)
              .map((e) => Category.fromJson(e))
              .toList();

          return categories;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Server error ${response.statusCode}");
      }
    } catch (e) {
      print("FETCH ERROR: $e");
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> addCategory(String name) async {
    try {
      final uuid = const Uuid().v4();

      final body = {"category_id": uuid, "name": name};
      print("Add Category");
      print("Body: $body");

      final response = await apiClient.dio.post("/categories/add/", data: body);

      print("Status code: ${response.statusCode}");
      print("Response : ${response.data}");

      return response.data;
    } catch (e) {
      if (e is DioException) {
        print("STATUS CODE: ${e.response?.statusCode}");
        print("ERROR BODY: ${e.response?.data}");
      }

      return {};
    }
  }

  Future<void> deleteCategory(List<String> ids) async {
    try {
      final body = {"ids": ids};

      print("Delete Category");
      print("body: $body");

      final response = await apiClient.dio.delete(
        "/categories/delete/",
        data: body,
      );

      print("Status code: ${response.statusCode}");
      print("Response: ${response.data}");
    } catch (e) {
      print("deleteCategory error: $e");
      rethrow;
    }
  }
}
