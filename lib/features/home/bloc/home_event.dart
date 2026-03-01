import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends HomeEvent {}

class FetchCategories extends HomeEvent {}


class SaveTransactionEvent extends HomeEvent {
  final String title;
  final double amount;
  final bool isExpense;
  final String? categoryId;

  const SaveTransactionEvent({
    required this.title,
    required this.amount,
    required this.isExpense,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [title, amount, isExpense, categoryId];
}

class DeleteTransactionEvent extends HomeEvent {
  final List<String> ids;

  const DeleteTransactionEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}