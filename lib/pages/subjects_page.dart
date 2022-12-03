import 'package:flutter/material.dart';
import 'package:memolang/models/subject.dart';

class SubjectsPageArguments {
  List<Subject> subjects;
  String token;

  SubjectsPageArguments({ required this.subjects, required this.token });
}

class SubjectsPage extends StatefulWidget {
  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Subjects')),
      body: const Center(
        child: Text('STUDY SUBJECTS GO HERE'),
      ),
      floatingActionButton: const FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}
