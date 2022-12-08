import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:memolang/models/subject.dart';
import 'package:memolang/style.dart';

class StudyPageArguments {
  final Subject subject;
  final String token;

  StudyPageArguments({required this.subject, required this.token});
}

class StudyPage extends StatefulWidget {
  const StudyPage({Key? key}) : super(key: key);

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  StudyPageArguments? args;
  int flashCardIndex = 0;
  bool showAnswer = false;

  void goToSplashAfterRender() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed("/");
    });
  }

  @override
  Widget build(BuildContext context) {
    args = (args == null)
        ? ModalRoute.of(context)?.settings.arguments as StudyPageArguments?
        : args;
    if (args == null) {
      goToSplashAfterRender();
    }
    return Scaffold(
      appBar: AppBar(title: Text(args?.subject.name ?? "")),
      body: Center(
        child: Container(
          height: cardWidth,
          width: cardWidth,
          padding: const EdgeInsets.all(padding),
          child: Card(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(padding),
                      child: Text(
                        (showAnswer) ? 'Answer' : 'Question',
                        style: TextStyle(
                          color: red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: padding),
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: Text(
                      (showAnswer)
                          ? args?.subject.flashCards[flashCardIndex].answer ??
                              ''
                          : args?.subject.flashCards[flashCardIndex].question ??
                              '',
                    ),
                  ),
                  _renderButtons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
            icon: const Icon(Icons.close),
            onPressed: () {
              flashCardIndex += 1;
              if (flashCardIndex == args?.subject.flashCards.length) {
                goToSplashAfterRender();
              }
            },
            label: const Text("Forgotten")),
        ElevatedButton(
            onPressed: () {
              setState(() {
                showAnswer = !showAnswer;
              });
            },
            child: Text((showAnswer) ? "Show Question" : "Show Answer")),
        ElevatedButton.icon(
            icon: const Icon(Icons.check),
            onPressed: () {
              flashCardIndex += 1;
              if (flashCardIndex == args?.subject.flashCards.length) {
                goToSplashAfterRender();
              }
            },
            label: const Text("Known")),
      ],
    );
  }
}
