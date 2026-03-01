import 'profile_event.dart';
import 'profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/profile/repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {

    on<FetchCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        final categories = await repository.fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<AddCategoryEvent>((event, emit) async {
      try {
        await repository.addCategory(event.name);

        final categories = await repository.fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<DeleteCategoryEvent>((event, emit) async {
      try {
        if (state is CategoryLoaded) {
          final currentState = state as CategoryLoaded;

          await repository.deleteCategory(event.ids);

          final updatedList = currentState.categories
              .where((category) => category.categoryid != event.ids)
              .toList();

          emit(CategoryLoaded(updatedList));
        }
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}