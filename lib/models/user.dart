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
  String? secret_key;
  String? gender;

  bool isImageNull() {
    return image == null;
  }

  isAgeRangeNull() {
    return age_range == null;
  }

  User({
    required this.id,
    required this.name,
    required this.email,
    this.mobile,
    this.country,
    this.city,
    this.age_range,
    this.image,
    required this.secret_key,
    this.gender,
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
      secret_key: json['secret_key'],
      gender: json['gender'],
    );
  }

  //methods called tojson
  Map<String, String> tojson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile ?? '',
      'country': country ?? '',
      'city': city ?? '',
      'age_range': age_range ?? '',
      'profile_image': image ?? '',
      'secret_key': secret_key ?? '',
    };
  }
}
