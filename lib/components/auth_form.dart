import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:memolang/clients/auth_client.dart';
import 'package:memolang/models/token_storage.dart';
import 'package:memolang/pages/splash_page.dart';
import 'package:memolang/style.dart';

class AuthForm extends StatefulWidget {
  final AuthClient authClient;

  AuthForm({required this.authClient});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _login(LoginData data) async {
    var authResult = await widget.authClient
        .login(Credentials(username: data.name, password: data.password));
    if (authResult.token != null) {
      TokenStorage.writeToken(authResult.token!);
      return null;
    }
    return authResult.error;
  }

  Future<String?> _sendOtp(SignupData data) async {
    var otpError = await widget.authClient.otp(data.name!);
    if (otpError != null) {
      return otpError.humanReadableError;
    }
    return null;
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _onConfirmSignup(String otp, LoginData data) async {
    var result = await widget.authClient.register(
        Credentials(username: data.name, password: data.password), otp);
    if (result.error != null) {
      return result.error!;
    }
    await TokenStorage.writeToken(result.token!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _login,
      onSignup: _sendOtp,
      onConfirmSignup: _onConfirmSignup,
      confirmSignupKeyboardType: TextInputType.number,
      logo: "assets/logo-no-background.png",
      onSubmitAnimationCompleted: () {
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
