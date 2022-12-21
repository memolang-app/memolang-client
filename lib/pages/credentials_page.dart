import 'package:flutter/material.dart';
import 'package:memolang/clients/auth_client.dart';
import 'package:memolang/components/auth_form.dart';
import 'package:memolang/style.dart';

class CredentialsPage extends StatelessWidget {
  var authClient = AuthClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: AuthForm(authClient: authClient),
    );
  }
}
