import 'package:flutter/material.dart';
import 'package:memolang/models/subject.dart';
import 'package:memolang/pages/study_page.dart';
import 'package:memolang/style.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final String token;
  final Future<void> Function(Subject) onFlashCardAddPressed;

  const SubjectCard(
      {required this.subject,
      required this.onFlashCardAddPressed,
      required this.token});

  int countFlashCardsOfStage(String stage) {
    return subject.flashCards
        .fold(0, (sum, card) => (card.stage == stage) ? sum + 1 : sum);
  }

  Widget _renderCardCountRow(String label, String stage) =>
      _renderKeyValueRow(label, countFlashCardsOfStage(stage).toString());

  Widget _renderKeyValueRow(String key, String value) => Padding(
        padding: const EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              padding: EdgeInsets.all(0),
              label: Text(key),
            ),
            Chip(
              padding: EdgeInsets.all(0),
              label: Text(value),
            )
          ],
        ),
      );

  Widget _renderButtons(BuildContext context) => Padding(
        padding: const EdgeInsets.all(padding * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  onFlashCardAddPressed(subject);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add card')),
            ElevatedButton.icon(
                onPressed: () {
                  if (subject.flashCardsToStudy.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: const Text("There is no card to study in this subject for today"),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text("Ok"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  Navigator.pushReplacementNamed(context, '/study',
                      arguments: StudyPageArguments(
                        subject: subject,
                        token: token,
                      ));
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Study')),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: const BoxConstraints(maxWidth: cardWidth),
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
              _renderKeyValueRow('Cards To Study',
                  subject.flashCardsToStudy.length.toString()),
              const Divider(height: padding),
              _renderButtons(context)
            ],
          ),
        ),
      ),
    );
  }
}
