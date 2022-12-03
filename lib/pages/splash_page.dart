import 'package:flutter/material.dart';
import 'package:memolang/models/token_storage.dart';
import 'package:memolang/pages/subjects_page.dart';
import 'package:splash_view/splash_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:memolang/style.dart';
import 'package:flutter/scheduler.dart';
import 'package:memolang/models/subject.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var tokenLoadingFailed = false;
  var shouldGoToSubjectsPage = false;
  String? token = null;
  var subjects = <Subject>[];
  static const splashMinMilliSeconds = 5000;

  Future<void> loadSubjects() async {
    var stopWatch = Stopwatch();
    stopWatch.start();
    token = await TokenStorage.readToken();
    if (token == null) {
      setStateWithMinSplashTime(stopWatch, () {
        tokenLoadingFailed = true;
      });
      return;
    }
    setStateWithMinSplashTime(stopWatch, () {
      subjects = []; // TODO: Fetch!!
      shouldGoToSubjectsPage = true;
    });
    // load subjects here.
  }

  void setStateWithMinSplashTime(
      Stopwatch stopwatch, VoidCallback stateUpdateFn) async {
    await Future.delayed(
        Duration(milliseconds: milliSecondsToWaitAfterResult(stopwatch)));
    setState(stateUpdateFn);
  }

  int milliSecondsToWaitAfterResult(Stopwatch stopwatch) {
    if (stopwatch.elapsedMilliseconds > splashMinMilliSeconds) {
      return 0;
    }
    return splashMinMilliSeconds - stopwatch.elapsedMilliseconds;
  }

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    if (tokenLoadingFailed) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed("/credentials");
      });
    }

    if (shouldGoToSubjectsPage) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed("/subjects",
            arguments:
                SubjectsPageArguments(subjects: subjects, token: token!));
      });
    }

    return SplashView(
      logo: Image.asset(
        "assets/logo-no-background.png",
        width: 200.0,
      ),
      loadingIndicator: Padding(
        padding: const EdgeInsets.all(50.0),
        child: SpinKitFoldingCube(
          color: Colors.red[600],
          size: 50.0,
        ),
      ),
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[splashGradiantColorMin, splashGradiantColorMax]),
    );
  }
}
