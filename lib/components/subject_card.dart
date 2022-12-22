import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memolang/models/subject.dart';
import 'package:memolang/pages/study_page.dart';
import 'package:memolang/style.dart';
import 'package:pie_chart/pie_chart.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final String token;
  final Future<void> Function(Subject) onFlashCardAddPressed;

  const SubjectCard(
      {required this.subject,
      required this.onFlashCardAddPressed,
      required this.token});

  double _countCardsOfStage(String stage) {
    return subject.flashCards
        .fold(0, (sum, card) => (card.stage == stage) ? sum + 1 : sum);
  }

  Widget _renderCardCountRow(String label, String stage) =>
      _renderKeyValueRow(label, _countCardsOfStage(stage).toString());

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
    Map<String, double> chartDataMap = {
      'Every Day': _countCardsOfStage('EVERY_DAY'),
      'Every Other Day': _countCardsOfStage('EVERY_TWO_DAY'),
      'Every Week': _countCardsOfStage('EVERY_WEEK'),
      'Every Other Week': _countCardsOfStage('EVERY_TWO_WEEK'),
      'Every Month': _countCardsOfStage('EVERY_MONTH'),
      'Learnt': _countCardsOfStage('DONE'),
    };
    return Card(
      child: Container(
        constraints: const BoxConstraints(maxWidth: cardWidth),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  const Utf8Decoder().convert(subject.name.codeUnits),
                  style: TextStyle(
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Divider(height: padding),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PieChart(
                    dataMap: chartDataMap,
                    chartValuesOptions: const ChartValuesOptions(decimalPlaces: 0)
                ),
              ),
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
