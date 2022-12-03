import 'package:flutter/material.dart';
import 'package:memolang/pages/credentials_page.dart';
import 'package:memolang/pages/splash_page.dart';
import 'package:memolang/pages/subjects_page.dart';
import 'package:memolang/style.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (ctx) => SplashPage(),
      '/subjects': (ctx) => SubjectsPage(),
      '/credentials': (ctx) => CredentialsPage(),
    },
    theme: ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
          backgroundColor: red,
          centerTitle: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: red),
    ),
  ));
}
