import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  void _submitForm(subjectName) {
    Navigator.of(context).pop(Subject(name: subjectName));
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
                      onSubmitted: (value) {
                        _submitForm(subjectNameInput.text);
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
                    _submitForm(subjectNameInput.text);
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
        child: SubjectList(subjects: subjectsPageArguments?.subjects),
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
