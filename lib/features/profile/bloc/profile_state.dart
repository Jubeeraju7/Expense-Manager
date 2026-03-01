import 'package:proactive_expense_manager/features/home/model/category_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class CategoryLoading extends ProfileState {}

class CategoryLoaded extends ProfileState {
  final List<Category> categories;

  CategoryLoaded(this.categories);
}

class CategoryError extends ProfileState {
  final String message;

  CategoryError(this.message);
}
