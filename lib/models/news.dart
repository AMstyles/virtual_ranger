class News {
  String title;
  String news_text;
  String news_image;
  String news_post_date;

  News({
    required this.title,
    required this.news_text,
    required this.news_image,
    required this.news_post_date,
  });

  static News fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      news_text: json['news_text'],
      news_image: json['news_image'],
      news_post_date: json['news_post_date'],
    );
  }
}
