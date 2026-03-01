import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:proactive_expense_manager/core/network/api_client.dart';
import 'package:proactive_expense_manager/features/home/model/category_model.dart';

class HomeRepository {
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

  Future<Map<String, dynamic>> getTransactions() async {
    try {
      final response = await apiClient.dio.get("/transactions/");
      print("Transaction API calling..$response");
      return response.data;
    } catch (e) {
      print("getTransactions error: $e");
      return {"transactions": []};
    }
  }

  Future<Map<String, dynamic>> addTransactions(
    Map<String, dynamic> body,
  ) async {
    try {
      print("Body: $body");
      final response = await apiClient.dio.post(
        "/transactions/add/",
        data: jsonEncode(body),
      );
      print("Add Transaction API calling..$response");
      print("Status code: ${response.statusCode}");
      print("Response : ${response.data}");
      await getTransactions();

      return response.data;
    } catch (e) {
      print("addTransactions error: $e");
      return {};
    }
  }

  Future<Map<String, dynamic>> deleteTransactions(List<String> ids) async {
    try {
      final response = await apiClient.dio.delete(
        "/transactions/delete/",
        data: {"ids": ids},
      );
      print("Delete Transaction API calling..$response");
      print("Status code: ${response.statusCode}");
      print("Response : ${response.data}");
      return response.data;
    } catch (e) {
      print("deleteTransactions error: $e");
      return {};
    }
  }
}
