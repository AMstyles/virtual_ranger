class User {
  String id;
  String name;
  String email;
  String? mobile;
  String? country;
  String? city;
  String? age_range;
  //String? password;
  String? image;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.country,
    this.city,
    this.age_range,
    this.image,
  });

  static User fromjson(json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      country: json['country'],
      city: json['city'],
      age_range: json['age_range'],
      image: json['profile_image'],
    );
  }
}
