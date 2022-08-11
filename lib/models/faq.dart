class FAQ {
  String question;
  String answer;

  FAQ({required this.question, required this.answer});

  static FAQ fromJson(Map<String, dynamic> json) {
    return FAQ(
      question: json['question'],
      answer: json['answer'],
    );
  }
}
