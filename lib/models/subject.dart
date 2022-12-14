class FlashCard {
  int? id;
  String question;
  String answer;
  String stage;
  bool shouldBeStudied;

  FlashCard({
    this.id,
    required this.question,
    required this.answer,
    required this.stage,
    required this.shouldBeStudied,
  });
}

class Subject {
  int id;
  String name;
  List<FlashCard> flashCards;
  List<FlashCard> flashCardsToStudy = [];

  Subject({required this.name, required this.id, required this.flashCards}) {
    flashCardsToStudy =
        flashCards.where((card) => card.shouldBeStudied).toList();
  }
}
