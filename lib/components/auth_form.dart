import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:memolang/clients/auth_client.dart';
import 'package:memolang/models/token_storage.dart';
import 'package:memolang/pages/otp_page.dart';
import 'package:memolang/pages/splash_page.dart';
import 'package:memolang/style.dart';

class AuthForm extends StatefulWidget {
  final AuthClient authClient;

  AuthForm({required this.authClient});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool shouldGoToOtpPage = false;

  Duration get loginTime => Duration(milliseconds: 2250);
  String otpUsername = "";
  String otpPassword = "";

  Future<String?> _login(LoginData data) async {
    var authResult = await widget.authClient
        .login(Credentials(username: data.name, password: data.password));
    if (authResult.token != null) {
      TokenStorage.writeToken(authResult.token!);
      return null;
    }
    return authResult.error;
  }

  Future<String?> _signupUser(SignupData data) async {
    var otpError = await widget.authClient.otp(data.name!);
    if (otpError != null) {
      return otpError.humanReadableError;
    }
    shouldGoToOtpPage = true;
    otpUsername = data.name!;
    otpPassword = data.password!;
    return null;
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _login,
      onSignup: _signupUser,
      logo: "assets/logo-no-background.png",
      onSubmitAnimationCompleted: () {
        if (shouldGoToOtpPage) {
          Navigator.of(context).pushReplacementNamed('/otp',
              arguments:
                  OtpPageArgs(email: otpUsername, password: otpPassword));
          return;
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SplashPage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      hideForgotPasswordButton: true,
      theme: LoginTheme(
          pageColorLight: backgroundColor,
          pageColorDark: backgroundColor,
          primaryColor: red,
          accentColor: red,
          inputTheme: InputDecorationTheme(
            filled: true,
            fillColor: backgroundColor,
            focusColor: backgroundColor,
          )),
    );
  }
}
