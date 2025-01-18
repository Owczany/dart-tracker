class Player {
  final String name;
  List<int> scores;

  Player({required this.name}) : scores = [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'scores': scores,
    };
  }

  static Player fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
    )..scores = List<int>.from(json['scores']);
  }
}
