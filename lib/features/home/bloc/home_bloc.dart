import 'home_event.dart';
import 'home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/home/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadTransactionsEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final data = await repository.getTransactions();
        emit(HomeLoaded(transactions: data['transactions'] ?? []));
      } catch (e) {
        emit(HomeError(message: e.toString()));
      }
    });
       on<FetchCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await repository.fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}