///Klasa przchowująca informacje o graczu
class Player {
  final String name;
  List<int> scores;
  bool getsIn; // informuje, czy gracz wszedł do gry

  Player({required this.name}) : scores = [], getsIn = false;

  //Resetuje punkty gracza
  void resetScores() {
    scores = [];
    getsIn = false;
  }

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
