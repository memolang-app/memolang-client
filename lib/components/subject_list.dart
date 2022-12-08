import 'package:flutter/material.dart';
import 'package:memolang/components/subject_card.dart';
import 'package:memolang/models/subject.dart';

class SubjectList extends StatelessWidget {
  final List<Subject>? subjects;
  final String token;
  final Future<void> Function(Subject) onFlashCardAddPressed;

  const SubjectList({required this.subjects, required this.onFlashCardAddPressed, required this.token});

  @override
  Widget build(BuildContext context) {
    if (subjects == null || subjects!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: Text('Press on the button to create a new subject')),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: subjects!
          .map((subject) => Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
            child: SubjectCard(subject: subject, onFlashCardAddPressed: onFlashCardAddPressed, token: token),
          ))
          .toList(),
    );
  }
}
