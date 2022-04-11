import 'package:flutter/services.dart';
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
      final stringUrl = _getFileName(request.url.toString());
      final stream = rootBundle
          .load("assets/mode_demo/" + stringUrl + ".json")
          .asStream()
          .map((event) => event.buffer.asUint8List());
      return StreamedResponse(stream, 200);
    }
  }

  String _getFileName(String url) {
    if (url.endsWith("/favoris/offres-immersion")) return "favoris_ids_immersion";
    if (url.endsWith("/favoris/offres-emploi")) return "favoris_ids_offres_emploi";
    if (url.endsWith("/favoris/services-civique")) return "favoris_ids_service_civique";
    if (url.endsWith("/actions")) return "favoris_ids_service_civique";
    return "";
  }
}
