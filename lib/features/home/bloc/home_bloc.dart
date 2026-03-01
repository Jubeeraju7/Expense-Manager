import 'home_event.dart';
import 'home_state.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/home/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(CategoryLoading());

      try {
        final categories = await repository.fetchCategories();
        emit(CategoryLoaded( categories: categories, ));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<LoadTransactionsEvent>((event, emit) async {
      emit(HomeLoading());

      try {
        final data = await repository.getTransactions();

        emit(HomeLoaded(transactions: data['transactions'] ?? []));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });

    on<SaveTransactionEvent>((event, emit) async {
      emit(TransactionSaving());

      try {
        final transaction = {
          "id": const Uuid().v4(),
          "amount": event.amount,
          "note": event.title,
          "type": event.isExpense ? "debit" : "credit",
          "category_id": event.categoryId,
          "timestamp": DateTime.now().toIso8601String(),
        };

        final body = {
          "transactions": [transaction],
        };

        await repository.addTransactions(body);
        emit(TransactionSaved());
        add(LoadTransactionsEvent());
      } catch (e) {
        emit(TransactionSaveError(e.toString()));
      }
    });

    /// DELETE TRANSACTION
    on<DeleteTransactionEvent>((event, emit) async {
      if (state is! HomeLoaded) return;

      final currentState = state as HomeLoaded;

      emit(HomeLoading());

      try {
        await repository.deleteTransactions(event.ids);

        final updatedTransactions = currentState.transactions
            .where((tx) => !event.ids.contains(tx['id']))
            .toList();

        emit(HomeLoaded(transactions: updatedTransactions));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });
  }
}
