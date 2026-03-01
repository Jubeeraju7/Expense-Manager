abstract class ProfileEvent {}

class FetchCategoriesEvent extends ProfileEvent {}

class AddCategoryEvent extends ProfileEvent {
  final String name;
  AddCategoryEvent(this.name);
}

class DeleteCategoryEvent extends ProfileEvent {
  final List<String> ids;

  DeleteCategoryEvent(this.ids);

  @override
  List<Object?> get props => [ids];
}