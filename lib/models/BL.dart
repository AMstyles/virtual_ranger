class BusinessListing {
  String logo;
  String name;
  String businesType;
  String email;
  String firstNumber;
  String secondNumber;
  String thirdNumber;
  String address;
  String openingHours;
  String type;

  BusinessListing({
    required this.logo,
    required this.name,
    required this.businesType,
    required this.email,
    required this.firstNumber,
    required this.secondNumber,
    required this.thirdNumber,
    required this.address,
    required this.openingHours,
    required this.type,
  });

  static BusinessListing fromJson(Map<String, dynamic> json) => BusinessListing(
        logo: json['logo'],
        name: json['name'],
        businesType: json['businesType'],
        email: json['email'],
        firstNumber: json['firstNumber'],
        secondNumber: json['secondNumber'],
        thirdNumber: json['thirdNumber'],
        address: json['address'],
        openingHours: json['openingHours'],
        type: json['type'],
      );
}
