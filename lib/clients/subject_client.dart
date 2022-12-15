import 'package:memolang/clients/base_http_client.dart';
import 'package:memolang/models/subject.dart';
import 'dart:convert';

class SubjectClient extends BaseHttpClient {
  Future<List<Subject>> listSubjects(String token) async {
    var response = await get("/api/study-subject", token: token);
    List<dynamic> decodedSubjects = jsonDecode(response.body);
    return decodedSubjects
        .map((decodedSubject) => toSubject(decodedSubject))
        .toList();
  }

  Future<bool> submitReview(
      String token, int subjectId, int cardId, bool remembered) async {
    var response = await post(
      "/api/study-subject/$subjectId/cards/$cardId/reviews",
      {"known": remembered},
      token: token,
    );
    return response.statusCode == 200;
  }

  Future<Subject?> createSubject(String token, String name) async {
    var response = await post(
      "/api/study-subject",
      {'name': name},
      token: token,
    );
    if (response.statusCode != 201) {
      return null;
    }
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return toSubject(responseBody);
  }

  Future<Subject?> addFlashCard(
      String token, int subjectId, String question, String answer) async {
    var response = await post(
      "/api/study-subject/$subjectId/cards",
      {
        'question': question,
        'answer': answer,
      },
      token: token,
    );
    if (response.statusCode != 201) {
      return null;
    }
    Map<String, dynamic> responseBody = jsonDecode(response.body);
    return toSubject(responseBody);
  }

  Subject toSubject(Map<String, dynamic> subjectJson) {
    return Subject(
        id: subjectJson['id'] as int,
        name: subjectJson['name'] as String,
        flashCards: (subjectJson['flashCards'] as List<dynamic>)
            .map((card) => toFlashCard(card))
            .toList());
  }

  FlashCard toFlashCard(dynamic cardDynamic) {
    return FlashCard(
        id: cardDynamic['id'] as int,
        question: cardDynamic['question'] as String,
        answer: cardDynamic['answer'] as String,
        stage: cardDynamic['stage'] as String,
        shouldBeStudied: cardDynamic['shouldBeStudied'] as bool);
  }
}
