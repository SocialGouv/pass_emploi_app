import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/network/filtres_request.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class OffreEmploiRepository extends RechercheRepository<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi> {
  static const PAGE_SIZE = 50;

  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  OffreEmploiRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  @override
  Future<RechercheResponse<OffreEmploi>?> rechercher({
    required String userId,
    required RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request,
  }) async {
    final url = Uri.parse(_baseUrl + "/offres-emploi").replace(
      query: _createQuery(request),
    );
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        final list = (json["results"] as List).map((offre) => OffreEmploi.fromJson(offre)).toList();
        return RechercheResponse(canLoadMore: list.length == PAGE_SIZE, results: list);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  String _createQuery(RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request) {
    final result = StringBuffer();
    var separator = "";

    void writeParameter(String key, String value) {
      result.write(separator);
      separator = "&";
      result.write(Uri.encodeQueryComponent(key));
      result.write("=");
      result.write(Uri.encodeQueryComponent(value));
    }

    if (request.criteres.onlyAlternance) {
      writeParameter("alternance", true.toString());
    }
    writeParameter("page", request.page.toString());
    writeParameter("limit", PAGE_SIZE.toString());
    if (request.criteres.keyword.isNotEmpty) {
      writeParameter("q", request.criteres.keyword);
    }
    if (request.criteres.location?.type == LocationType.DEPARTMENT) {
      writeParameter("departement", request.criteres.location!.code);
    }
    if (request.criteres.location?.type == LocationType.COMMUNE) {
      writeParameter("commune", request.criteres.location!.code);
    }
    if (request.filtres.distance != null) {
      writeParameter("rayon", request.filtres.distance.toString());
    }
    if (request.filtres.debutantOnly != null) {
      writeParameter("debutantAccepte", request.filtres.debutantOnly.toString());
    }
    request.filtres.experience?.forEach((element) {
      writeParameter("experience", FiltresRequest.experienceToUrlParameter(element));
    });
    request.filtres.contrat?.forEach((element) {
      writeParameter("contrat", FiltresRequest.contratToUrlParameter(element));
    });
    request.filtres.duree?.forEach((element) {
      writeParameter("duree", FiltresRequest.dureeToUrlParameter(element));
    });
    return result.toString();
  }
}

extension Encoded on StringBuffer {
  void writeEncoded(String string) {
    write(Uri.encodeQueryComponent(string));
  }
}

class OffreEmploiSearchResponse {
  final bool isMoreDataAvailable;
  final List<OffreEmploi> offres;

  OffreEmploiSearchResponse({required this.isMoreDataAvailable, required this.offres});
}
