import 'package:equatable/equatable.dart';
import 'package:proactive_expense_manager/features/home/model/category_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> transactions;

  const HomeLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class TransactionSaving extends HomeState {}

class TransactionSaved extends HomeState {}

class TransactionSaveError extends HomeState {
  final String message;

  const TransactionSaveError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryLoading extends HomeState {}

class CategoryLoaded extends HomeState {
  final List<Category> categories;
  final String? selectedCategoryId;

  const CategoryLoaded({required this.categories, this.selectedCategoryId});

  CategoryLoaded copyWith({
    List<Category>? categories,
    String? selectedCategoryId,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [categories, selectedCategoryId];
}

class CategoryError extends HomeState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
