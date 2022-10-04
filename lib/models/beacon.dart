class beacon {
  String name;
  String uuid;
  int major;
  int minor;
  String proximity;
  String content;

  beacon(
      {required this.name,
      required this.uuid,
      required this.major,
      required this.minor,
      required this.proximity,
      required this.content});

  factory beacon.fromJson(Map<String, dynamic> json) {
    return beacon(
      name: json['name'],
      uuid: json['uuid'],
      major: json['major'],
      minor: json['minor'],
      proximity: json['proximity'],
      content: json['content'],
    );
  }
}
