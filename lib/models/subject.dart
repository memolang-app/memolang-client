class FlashCard {
  int? id;
  String question;
  String answer;
  String stage;

  FlashCard({
    this.id,
    required this.question,
    required this.answer,
    required this.stage
  });
}

class Subject {
  int id;
  String name;
  List<FlashCard> flashCards;

  Subject({required this.name, required this.id, required this.flashCards });
}
