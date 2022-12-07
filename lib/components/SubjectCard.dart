import 'package:flutter/material.dart';
import 'package:memolang/models/subject.dart';
import 'package:memolang/style.dart';
import 'package:badges/badges.dart';


class SubjectCard extends StatelessWidget {
  final Subject subject;
  final Future<void> Function(Subject) onFlashCardAddPressed;

  const SubjectCard({required this.subject, required this.onFlashCardAddPressed});
  static const double padding = 8.0;

  int countFlashCardsOfStage(String stage) {
    return subject.flashCards
        .fold(0, (sum, card) => (card.stage == stage) ? sum + 1 : sum);
  }

  Widget _renderCardCountRow(String label, String stage) => Padding(
    padding: const EdgeInsets.all(padding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Chip(
          padding: EdgeInsets.all(0),
          label: Text(label),
        ),
        Chip(
          padding: EdgeInsets.all(0),
          label: Text(countFlashCardsOfStage(stage).toString()),
        )
      ],
    ),
  );

  Widget _renderButtons() => Padding(
    padding: const EdgeInsets.all(padding  * 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
            onPressed: () {
              onFlashCardAddPressed(subject);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add card')
        ),
        ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.book),
            label: const Text('Study')
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subject.name,
                  style: TextStyle(
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Divider(height: padding),
              _renderCardCountRow('Study Every Day', 'EVERY_DAY'),
              const Divider(height: padding),
              _renderCardCountRow('Study Every Two Day', 'EVERY_TWO_DAY'),
              const Divider(height: padding),
              _renderCardCountRow('Study Every Week', 'EVERY_WEEK'),
              const Divider(height: padding),
              _renderCardCountRow('Study Every Two Week', 'EVERY_TWO_WEEK'),
              const Divider(height: padding),
              _renderCardCountRow('Study every month', 'EVERY_MONTH'),
              const Divider(height: padding),
              _renderCardCountRow('Learnt', 'DONE'),
              const Divider(height: padding),
              _renderButtons()
            ],
          ),
        ),
      ),
    );
  }
}
