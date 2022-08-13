class Specy {
  String id;
  String english_name;
  String afrikaans_name;
  String scientific_name;
  String subcategory_id;
  String description;
  String range_habitat;
  String behaviour;
  String rank;
  String higher_classification;
  String tags;

  Specy({
    required this.range_habitat,
    required this.id,
    required this.english_name,
    required this.afrikaans_name,
    required this.scientific_name,
    required this.subcategory_id,
    required this.description,
    required this.behaviour,
    required this.rank,
    required this.higher_classification,
    required this.tags,
  });

  static Specy fromJson(Map<String, dynamic> json) {
    return Specy(
      range_habitat: json['range_habitat'],
      id: json['id'],
      english_name: json['english_name'],
      afrikaans_name: json['afrikaans_name'],
      scientific_name: json['scientific_name'],
      subcategory_id: json['subcategory_id'],
      description: json['description'],
      behaviour: json['behaviour'],
      rank: json['rank'],
      higher_classification: json['higher_classification'],
      tags: json['tags'],
    );
  }
}
