class SubCategory {
  String id;
  String name;
  String description;
  String BackgroundImage;
  String categoryId;

  SubCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.BackgroundImage,
    required this.categoryId,
  });

  static SubCategory fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      BackgroundImage: json['background_image'],
      categoryId: json['category_id'],
    );
  }
}
