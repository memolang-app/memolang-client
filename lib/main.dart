import 'package:flutter/material.dart';
import 'package:memolang/pages/splash_page.dart';
import 'package:memolang/pages/subjects_page.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (ctx) => SplashPage(),
      '/subjects': (ctx) => SubjectsPage(),
    },
  ));
}
