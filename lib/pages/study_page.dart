import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:memolang/components/circular_icon_button.dart';
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
          constraints: BoxConstraints(maxHeight: cardWidth),
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
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

  void setStateToNextCard() {
    setState(() {
      if (flashCardIndex >= (args?.subject.flashCards.length ?? 0) - 1) {
        goToSplashAfterRender();
        return;
      }
      flashCardIndex += 1;
    });
  }

  Widget _renderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularIconButton(onPressed: () {
          setStateToNextCard();
        }, icon: Icons.close),
        ElevatedButton(
            onPressed: () {
              setState(() {
                showAnswer = !showAnswer;
              });
            },
            style: ElevatedButton.styleFrom(primary: Colors.yellow[800]),
            child: Text((showAnswer) ? "Show Question" : "Show Answer")),
        CircularIconButton(onPressed: () {
          setStateToNextCard();
        }, icon: Icons.check),
      ],
    );
  }
}
