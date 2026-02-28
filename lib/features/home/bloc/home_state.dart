import 'package:equatable/equatable.dart';
import 'package:proactive_expense_manager/features/home/model/category_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> transactions;
  HomeLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class HomeError extends HomeState {
  final String message;
  HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CategoryInitial extends HomeState {}

class CategoryLoading extends HomeState {}

class CategoryLoaded extends HomeState {
  final List<Category> categories;

  CategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoryError extends HomeState {
  final String message;

  CategoryError(this.message);

  @override
  List<Object> get props => [message];
}