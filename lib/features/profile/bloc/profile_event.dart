abstract class ProfileEvent {}

class FetchCategoriesEvent extends ProfileEvent {}

class AddCategoryEvent extends ProfileEvent {
  final String name;
  AddCategoryEvent(this.name);
}

class DeleteCategoryEvent extends ProfileEvent {
  final String id;
  DeleteCategoryEvent(this.id);
}