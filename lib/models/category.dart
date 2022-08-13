class Category_ {
  String name;
  String description;
  String backgroundImage;
  String id;

  Category_(
      {required this.name,
      required this.description,
      required this.backgroundImage,
      required this.id});

  static Category_ fromJson(Map<String, dynamic> json) {
    return Category_(
      name: json['name'],
      description: json['description'],
      backgroundImage: json['background_image'],
      id: json['id'],
    );
  }
}
