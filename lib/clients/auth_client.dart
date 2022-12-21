import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:memolang/clients/base_http_client.dart';

class AuthError {
  static const usernameTaken = "This username is already taken";
  static const wrongCredentials = "Username and password don't match";
  static const unknownError = "Couldn't send the information to the server. Please try again";

  static const wrongOtp = "Wrong Code. Please try again!";
}

class AuthResult {
  String? token;
  String? error;

  AuthResult({ this.token, this.error });
}

class OtpError {
  String humanReadableError;

  OtpError({required this.humanReadableError});
}

class Credentials {
  String username;
  String password;

  Credentials({ required this.username, required this.password});

  Map<String, String> toMap() {
    return <String, String>{
      'username': username,
      'password': password,
    };
  }
}

class AuthClient extends BaseHttpClient {
  Future<AuthResult> login(Credentials credentials) async {
    var response = await super.post("/api/users/login", credentials.toMap());
    if (response.statusCode == 200) {
      return AuthResult(token: _extractTokenFromBody(response));
    } else if (response.statusCode == 401) {
      return AuthResult(error: AuthError.wrongCredentials);
    } else {
      return AuthResult(error: AuthError.unknownError);
    }
  }

  Future<OtpError?> otp(String email) async {
    var response = await super.post("/api/users/otp", {"claimedEmail": email});
    if (response.statusCode == 409) {
      return OtpError(humanReadableError: AuthError.usernameTaken);
    } else if (response.statusCode == 200) {
      return null;
    } else {
      return OtpError(humanReadableError: AuthError.unknownError);
    }
  }

  Future<AuthResult> register(Credentials credentials, String otp) async {
    var body = credentials.toMap();
    body.addAll({'otp': otp});
    var response = await super.post("/api/users", body);
    if (response.statusCode == 201) {
      return AuthResult(token: _extractTokenFromBody(response));
    } else if (response.statusCode == 409) {
      return AuthResult(error: AuthError.usernameTaken);
    } else if (response.statusCode == 401) {
      return AuthResult(error: AuthError.wrongOtp);
    } else {
      return AuthResult(error: AuthError.unknownError);
    }
  }

  String _extractTokenFromBody(Response response) {
    return jsonDecode(response.body)['token'] as String;
  }
}
