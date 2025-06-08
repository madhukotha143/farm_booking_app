class FarmHouse {
  final int id;
  final String title;

  FarmHouse({
    required this.id,
    required this.title,
  });

  // From JSON
  factory FarmHouse.fromJson(Map<String, dynamic> json) {
    return FarmHouse(
      id: json['id'],
      title: json['title'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
