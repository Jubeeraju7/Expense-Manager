class Category {
  final String categoryid;
  final String name;

  Category({
    required this.categoryid,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryid: json['category_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}