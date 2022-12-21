import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:memolang/clients/auth_client.dart';
import 'package:memolang/models/token_storage.dart';
import 'package:memolang/style.dart';

class OtpPageArgs {
  String email;
  String password;

  OtpPageArgs({required this.email, required this.password});
}

class OtpPage extends StatefulWidget {
  OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String? lastError;
  final AuthClient authClient = AuthClient();

  void goToSplashAfterRender(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed("/");
    });
  }

  @override
  Widget build(BuildContext context) {
    var argsWithoutType = ModalRoute.of(context)?.settings.arguments;
    if (argsWithoutType == null) {
      goToSplashAfterRender(context);
    }
    var args = argsWithoutType as OtpPageArgs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/logo-no-background.png",
            width: 200.0,
          ),
          const SizedBox(height: padding * 3),
          (lastError == null)
              ? const Text("Please enter the text sent to your email!")
              : Text(lastError!),
          const SizedBox(height: padding * 3),
          OtpTextField(
            numberOfFields: 5,
            filled: true,
            fillColor: Colors.white,
            borderColor: red,
            showFieldAsBox: true,
            onSubmit: (String verificationCode) async {
              await onSubmit(context, verificationCode, args);
            }, // end onSubmit
          ),
        ],
      ),
    );
  }

  Future<void> onSubmit(BuildContext context, String verificationCode, OtpPageArgs args) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Validating"),
            content: Text('Validating the code $verificationCode'),
          );
        });

    var registrationResponse = await authClient.register(
        Credentials(username: args.email, password: args.password),
        verificationCode);
    setState(() {
      lastError = registrationResponse.error;
    });
    Navigator.of(context).pop();
    if (registrationResponse.error == null) {
      await TokenStorage.writeToken(registrationResponse.token!);
      goToSplashAfterRender(context);
    }
  }
}
