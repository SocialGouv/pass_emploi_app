import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';

class ModeDemoClient extends BaseClient {
  final ModeDemoRepository repository;
  final Client httpClient;

  ModeDemoClient(this.repository, this.httpClient);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (!repository.getModeDemo() || !request.url.toString().isSupposedToBeMocked()) return httpClient.send(request);
    if (request.method != "GET") {
      return StreamedResponse(Stream.empty(), 201);
    } else {
      final stringUrl = _getFileName(request.url.path);
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
    if (url.endsWith("/actions")) return "actions_list";
    if (url.endsWith("/rendezvous")) return "rendez_vous_list";
    if (url.endsWith("/recherches")) return "saved_search";
    if (url.endsWith("/offres-emploi")) return "offres_emploi_list";
    if (url.endsWith("/offres-immersion")) return "offres_immersion_list";
    if (url.endsWith("/services-civique")) return "offres_services_civique";
    if (url.contains("/services-civique/")) return "service_civique_detail";
    if (url.contains("/offres-immersion/")) return "immersion_detail";
    if (url.contains("/offres-emploi/")) return "offre_emploi_detail";
    return "";
  }
}

extension _UrlExtensions on String {
  bool isSupposedToBeMocked() {
    return !contains("referentiels");
  }
}