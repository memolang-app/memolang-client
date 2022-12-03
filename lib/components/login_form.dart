import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:memolang/clients/auth_client.dart';
import 'package:memolang/models/token_storage.dart';
import 'package:memolang/pages/splash_page.dart';
import 'package:memolang/pages/subjects_page.dart';
import 'package:memolang/style.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginForm extends StatelessWidget {
  AuthClient authClient;

  LoginForm({ required this.authClient });

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _login(LoginData data) async {
    var authResult = await authClient.login(Credentials(
        username: data.name,
        password: data.password
    ));
    if (authResult.token != null) {
      TokenStorage.writeToken(authResult.token!);
      return null;
    }
    return authResult.error;
  }

  Future<String?> _signupUser(SignupData data) async {
    var authResult = await authClient.register(Credentials(
        username: data.name!,
        password: data.password!,
    ));
    if (authResult.token != null) {
      TokenStorage.writeToken(authResult.token!);
      return null;
    }
    return authResult.error;
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _login,
      onSignup: _signupUser,
      userValidator: (username) {
        if (username == null) {
          return "This field is required!";
        }
        if (username.contains(RegExp(r'\s'))) {
          return "Username should not contain any whitespace!";
        }
        return null;
      },
      logo: "assets/logo-no-background.png",
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SplashPage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      hideForgotPasswordButton: true,
      userType: LoginUserType.name,

      theme: LoginTheme(
          pageColorLight: backgroundColor,
          pageColorDark: backgroundColor,
          primaryColor: red,
          accentColor: red,
          inputTheme: InputDecorationTheme(
            filled: true,
            fillColor: backgroundColor,
            focusColor: backgroundColor,
          )
      ),
    );
  }
}

