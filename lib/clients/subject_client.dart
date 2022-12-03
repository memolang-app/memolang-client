
import 'package:memolang/clients/base_http_client.dart';
import 'package:memolang/models/subject.dart';

class SubjectClient extends BaseHttpClient {
  Future<Subject> listSubjects() async {
    return Subject(name: "name");
  }
}
