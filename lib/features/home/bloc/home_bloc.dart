import 'home_event.dart';
import 'home_state.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/home/model/category_model.dart';
import 'package:proactive_expense_manager/features/home/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchCategories>((event, emit) async {
      final currentTransactions = (state is HomeLoaded)
          ? (state as HomeLoaded).transactions
          : <dynamic>[];

      emit(HomeLoading());

      try {
        final categories = await repository.fetchCategories();
        emit(
          HomeLoaded(transactions: currentTransactions, categories: categories),
        );
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });

    on<LoadTransactionsEvent>((event, emit) async {
      final currentCategories = (state is HomeLoaded)
          ? (state as HomeLoaded).categories
          : <Category>[];

      emit(HomeLoading());

      try {
        final data = await repository.getTransactions();
        emit(
          HomeLoaded(
            transactions: data['transactions'] ?? [],
            categories: currentCategories,
          ),
        );
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });

    on<SaveTransactionEvent>((event, emit) async {
      if (state is! HomeLoaded) return;
      emit(TransactionSaving());
      try {
        final transaction = {
          "id": const Uuid().v4(),
          "amount": event.amount,
          "note": event.title,
          "type": event.isExpense ? "debit" : "credit",
          "category_id": event.categoryId ?? "unknown_id",
          "timestamp": DateTime.now().toIso8601String(),
        };

        final body = {
          "transactions": [transaction],
        };

        await repository.addTransactions(body);
        final fullData = await repository.getTransactions();
        final fullTransactions = fullData['transactions'] ?? [];
        print(
          "-----------------------------------Full Transactions after adding: $fullTransactions",
        );
        final currentTransactions = (state is HomeLoaded)
            ? (state as HomeLoaded).transactions
            : [];
        final currentCategories = (state is HomeLoaded)
            ? List<Category>.from((state as HomeLoaded).categories)
            : <Category>[];

        emit(
          HomeLoaded(
            transactions: currentTransactions,
            categories: currentCategories,
          ),
        );
      } catch (e) {
        emit(TransactionSaveError(e.toString()));
      }
    });

    on<DeleteTransactionEvent>((event, emit) async {
      if (state is! HomeLoaded) return;

      final currentState = state as HomeLoaded;

      emit(HomeLoading());

      try {
        await repository.deleteTransactions(event.ids);

        final updatedTransactions = currentState.transactions
            .where((tx) => !event.ids.contains(tx['id']))
            .toList();
        emit(
          HomeLoaded(
            transactions: updatedTransactions,
            categories: currentState.categories,
          ),
        );
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });
  }
}
