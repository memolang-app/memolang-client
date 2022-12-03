import 'package:memolang/clients/base_http_client.dart';
import 'package:memolang/models/subject.dart';
import 'dart:convert';

class SubjectClient extends BaseHttpClient {
  Future<List<Subject>> listSubjects(String token) async {
    var response = await get("/api/study-subject", token: token);
    List<dynamic> decodedSubjects = jsonDecode(response.body);
    return decodedSubjects.map(
        (decodedSubject) => Subject(name: decodedSubject["name"] as String)
    ).toList();
  }
}
