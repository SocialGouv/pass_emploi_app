import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';

class ModeDemoClient extends BaseClient {
  final ModeDemoRepository repository;
  final Client httpClient;

  ModeDemoClient(this.repository, Client httpClient) : httpClient = ModeDemoValidatorClient(httpClient);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (!repository.getModeDemo() || !request.url.toString().isSupposedToBeMocked()) return httpClient.send(request);
    if (request.method != "GET") {
      return StreamedResponse(Stream.empty(), 201);
    } else {
      final fileName = _getFileName(request.url.path, request.url.query);
      return StreamedResponse(readFileBytes(fileName!), 200);
    }
  }

  Stream<List<int>> readFileBytes(String stringUrl) {
    return rootBundle
        .load("assets/mode_demo/" + stringUrl + ".json") //
        .asStream() //
        .map((event) => event.buffer.asUint8List());
  }
}

class ModeDemoValidatorClient extends BaseClient {
  final Client httpClient;

  ModeDemoValidatorClient(this.httpClient);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (request.method == "GET" && request.url.toString().isSupposedToBeMocked()) {
      final fileName = _getFileName(request.url.path, request.url.query);
      if (fileName == null) throw ModeDemoException(request.url.toString());
    }
    return httpClient.send(request);
  }
}

class ModeDemoException implements Exception {
  final String _urlToBeMocked;

  ModeDemoException(String urlToBeMocked) : _urlToBeMocked = urlToBeMocked;

  @override
  String toString() {
    return '''
        URL $_urlToBeMocked is supposed to be mocked. 
        Please complete ModeDemoClient.dart or declare URL as not supposed to be mocked.
      '''
        .trim();
  }
}

String? _getFileName(String url, String query) {
  if (url.endsWith("/home/demarches")) return "home_demarches";
  if (url.endsWith("/home/actions")) return "home_actions";
  if (url.endsWith("/favoris/offres-immersion")) return "favoris_ids_immersion";
  if (url.endsWith("/favoris/offres-emploi")) return "favoris_ids_offres_emploi";
  if (url.endsWith("/favoris/services-civique")) return "favoris_ids_service_civique";
  if (url.endsWith("/rendezvous")) return "rendez_vous_list";
  if (url.endsWith("/recherches")) return "saved_search";
  if (url.endsWith("/offres-emploi") && query.contains("alternance=true")) return "alternance_list";
  if (url.endsWith("/offres-emploi")) return "offres_emploi_list";
  if (url.endsWith("alternance_detail")) return "alternance_detail";
  if (url.endsWith("/offres-immersion")) return "offres_immersion_list";
  if (url.endsWith("/services-civique")) return "offres_services_civique";
  if (url.endsWith("/preferences")) return "preferences";
  if (url.endsWith("/referentiels/pole-emploi/types-demarches")) return "referentiel_demarches";
  if (url.endsWith("/commentaires")) return "commentaires";
  if (url.removeLastPath().endsWith("/services-civique")) return "service_civique_detail";
  if (url.removeLastPath().endsWith("/offres-immersion")) return "immersion_detail";
  if (url.removeLastPath().endsWith("/offres-emploi")) return "offre_emploi_detail";
  if (url.removeLastPath().endsWith("/jeunes")) return "jeune_detail";
  return null;
}

extension _UrlExtensions on String {
  bool isSupposedToBeMocked() {
    return !contains("referentiels/communes-et-departements") && !contains("fichiers");
  }

  String removeLastPath() => substring(0, lastIndexOf('/'));
}
