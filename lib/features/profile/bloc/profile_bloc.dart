import 'profile_event.dart';
import 'profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proactive_expense_manager/features/profile/repository/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc(this.repository) : super(ProfileInitial()) {

    // Fetch categories
    on<FetchCategoriesEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        final categories = await repository.fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    // Add category
    on<AddCategoryEvent>((event, emit) async {
      try {
        await repository.addCategory(event.name);

        final categories = await repository.fetchCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    // Delete category
    on<DeleteCategoryEvent>((event, emit) async {
      try {
        if (state is CategoryLoaded) {
          final currentState = state as CategoryLoaded;

          await repository.deleteCategories([event.id]);

          final updatedList = currentState.categories
              .where((category) => category.id != event.id)
              .toList();

          emit(CategoryLoaded(updatedList));
        }
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}