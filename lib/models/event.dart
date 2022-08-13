class Event {
  String title;
  String event_image;
  String description;
  String start_date;
  String end_date;

  Event({
    required this.title,
    required this.event_image,
    required this.description,
    required this.start_date,
    required this.end_date,
  });

  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      event_image: json['event_image'],
      description: json['description'],
      start_date: json['start_date'],
      end_date: json['end_date'],
    );
  }
}
