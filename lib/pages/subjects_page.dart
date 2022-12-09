import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:memolang/clients/subject_client.dart';
import 'package:memolang/components/subject_list.dart';
import 'package:memolang/models/subject.dart';

class SubjectsPageArguments {
  List<Subject> subjects;
  String token;

  SubjectsPageArguments({required this.subjects, required this.token});
}

class SubjectsPage extends StatefulWidget {
  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  SubjectsPageArguments? subjectsPageArguments;
  TextEditingController subjectNameInput = TextEditingController();
  TextEditingController flashCardQuestionInput = TextEditingController();
  TextEditingController flashCardAnswerInput = TextEditingController();
  SubjectClient subjectClient = SubjectClient();

  void _submitNewSubjectForm(String subjectName) async {
    var subject = await subjectClient.createSubject(subjectsPageArguments!.token, subjectName);
    if (subject != null) {
      Navigator.of(context).pop(subject);
    } else {
      Navigator.of(context).pop();
    }
    subjectNameInput.clear();
  }

  Future<Subject?> _showNewSubjectDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Create new study subject'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                      style: const TextStyle(color: Colors.black),
                      onSubmitted: (value) {
                        _submitNewSubjectForm(subjectNameInput.text);
                      },
                      controller: subjectNameInput,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Name",
                      )),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  onPressed: () {
                    _submitNewSubjectForm(subjectNameInput.text);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
              ),
            ],
          ),
    );
  }

  void setStateWithNewSubject(Subject updatedSubject) {
    var foundSubject = subjectsPageArguments!.subjects.firstWhere((element) => element.id == updatedSubject.id);
    setState(() {
      foundSubject.flashCards = updatedSubject.flashCards;
    });
  }

  Future<Subject?> _show_new_card_dialog(Subject subject) {
    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Create new Flash Card'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                      style: const TextStyle(color: Colors.black),
                      onSubmitted: (value) {
                        _submitNewFlashCardForm(subject.id);
                      },
                      controller: flashCardQuestionInput,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "Question",
                      )),
                  TextField(
                      style: const TextStyle(color: Colors.black),
                      onSubmitted: (value) {
                        _submitNewFlashCardForm(subject.id);
                      },
                      controller: flashCardAnswerInput,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: "answer",
                      )),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Save"),
                  onPressed: () {
                    _submitNewFlashCardForm(subject.id);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
              ),
            ],
          ),
    );
  }

  Future<Subject?> _submitNewFlashCardForm(int subjectId) async {
    var subject = await subjectClient.addFlashCard(
        subjectsPageArguments!.token,
        subjectId,
        flashCardQuestionInput.text,
        flashCardAnswerInput.text,
    );
    if (subject != null) {
      Navigator.of(context).pop(subject);
    } else {
      Navigator.of(context).pop();
    }
    subjectNameInput.clear();
  }

  @override
  Widget build(BuildContext context) {
    subjectsPageArguments = (subjectsPageArguments == null)
        ? ModalRoute
        .of(context)
        ?.settings
        .arguments as SubjectsPageArguments?
        : subjectsPageArguments;
    if (subjectsPageArguments == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed("/");
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Subjects'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SubjectList(
          token: subjectsPageArguments?.token ?? '',
            subjects: subjectsPageArguments?.subjects,
            onFlashCardAddPressed: (subject) async {
              var newSubject = await _show_new_card_dialog(subject);
              if (newSubject != null) {
                setStateWithNewSubject(newSubject);
                flashCardAnswerInput.clear();
                flashCardQuestionInput.clear();
              }
            },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var newSubject = await _showNewSubjectDialog(context);
          if (newSubject != null) {
            setState(() {
              subjectsPageArguments!.subjects.add(newSubject);
            });
          }
        },
      ),
    );
  }
}
