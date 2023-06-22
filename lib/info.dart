class Information {
  final String title;
  final String body;

  Information({required this.title, required this.body});

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
      title: json['title'],
      body: json['body'],
    );
  }
}
