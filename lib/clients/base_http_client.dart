import 'package:http/http.dart' as http;
import 'dart:convert';

class BaseHttpClient {
  static var host = "http://localhost:8080";

  Future<http.Response> get(String path, { String? token }) {
    return http.get(
        Uri.parse(host + path),
        headers: tokenToHeaderMap(token),
    );
  }

  Future<http.Response> delete(String path, String token) {
    return http.delete(
      Uri.parse(host + path),
      headers: tokenToHeaderMap(token),
    );
  }

  Future<http.Response> post(String path, Map<String, dynamic> body, {String? token}) {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    headers.addAll(tokenToHeaderMap(token));
    return http.post(
      Uri.parse(host + path),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String path, Map<String, dynamic> body, {String? token}) {
    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    headers.addAll(tokenToHeaderMap(token));
    return http.put(
      Uri.parse(host + path),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Map<String, String> tokenToHeaderMap(String? token) {
    if (token == null) {
      return {};
    }
    return { "Authorization": "Bearer $token" };
  }
}
