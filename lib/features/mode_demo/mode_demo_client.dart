import 'dart:io';

import 'package:http/http.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';

class ModeDemoClient extends BaseClient {
  final ModeDemoRepository repository;
  final Client httpClient;

  ModeDemoClient(this.repository, this.httpClient);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (request.method != "GET") {
      return StreamedResponse(Stream.empty(), 201);
    } else {
      final stringUrl = request.url.path.toString().replaceAll("/", "|");
      final stream = File("assets/mode_demo/" + stringUrl + ".json");
      return StreamedResponse(stream.openRead(), 200);
    }
  }
}
