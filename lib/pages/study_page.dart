import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:memolang/clients/subject_client.dart';
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
  SubjectClient client = SubjectClient();

  void goToSplashAfterRender() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed("/");
    });
  }

  void onReviewButtonClicked(bool remembered) async {
    var reviewSubmitted = await sendReviewRequest(remembered);
    if (!reviewSubmitted) {
      goToSplashAfterRender();
    }
    setState(() {
      showAnswer = false;
    });
    setStateToNextCardOrSplash();
  }

  void setStateToNextCardOrSplash() {
    setState(() {
      if (flashCardIndex >= (args?.subject.flashCardsToStudy.length ?? 0) - 1) {
        goToSplashAfterRender();
        return;
      }
      flashCardIndex += 1;
    });
  }

  Future<bool> sendReviewRequest(bool remembered) async {
    if (args == null) {
      return false;
    }
    return await client.submitReview(args!.token, args!.subject.id,
        args!.subject.flashCardsToStudy[flashCardIndex].id!, remembered);
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {
          goToSplashAfterRender();
        },
      ),
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
                          ? args?.subject.flashCardsToStudy[flashCardIndex].answer ??
                              ''
                          : args?.subject.flashCardsToStudy[flashCardIndex].question ??
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

  Widget _renderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularIconButton(
            onPressed: () {
              onReviewButtonClicked(false);
            },
            icon: Icons.close),
        ElevatedButton(
            onPressed: () {
              setState(() {
                showAnswer = !showAnswer;
              });
            },
            style: ElevatedButton.styleFrom(primary: Colors.yellow[800]),
            child: Text((showAnswer) ? "Show Question" : "Show Answer")),
        CircularIconButton(
            onPressed: () {
              onReviewButtonClicked(true);
            },
            icon: Icons.check),
      ],
    );
  }
}
