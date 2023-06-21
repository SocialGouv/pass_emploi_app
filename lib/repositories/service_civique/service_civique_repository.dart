import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/service_civique/service_civique_filtres_recherche.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class ServiceCiviqueRepository
    extends RechercheRepository<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche, ServiceCivique> {
  static const PAGE_SIZE = 50;

  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ServiceCiviqueRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<RechercheResponse<ServiceCivique>?> rechercher({
    required String userId,
    required RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche> request,
  }) async {
    final url = Uri.parse("/services-civique").replace(query: _createQuery(request)).toString();
    try {
      final response = await _httpClient.get(url);
      final list = response.asListOf(ServiceCivique.fromJson);
      return RechercheResponse(results: list, canLoadMore: list.length == PAGE_SIZE);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  String _createQuery(RechercheRequest<ServiceCiviqueCriteresRecherche, ServiceCiviqueFiltresRecherche> request) {
    final result = StringBuffer();
    var separator = "";

    void writeParameter(String key, String value) {
      result.write(separator);
      separator = "&";
      result.write(Uri.encodeQueryComponent(key));
      result.write("=");
      result.write(Uri.encodeQueryComponent(value));
    }

    writeParameter("page", request.page.toString());
    writeParameter("limit", PAGE_SIZE.toString());
    if (request.criteres.location?.latitude != null) {
      writeParameter("lat", request.criteres.location!.latitude.toString());
    }
    if (request.criteres.location?.longitude != null) {
      writeParameter("lon", request.criteres.location!.longitude.toString());
    }
    if (request.filtres.distance != null) {
      writeParameter("distance", request.filtres.distance.toString());
    }
    if (request.filtres.startDate != null) {
      writeParameter("dateDeDebutMinimum", request.filtres.startDate!.toIso8601String());
    }
    if (request.filtres.domain != null) {
      writeParameter("domaine", request.filtres.domain!.tag);
    }
    return result.toString();
  }
}
