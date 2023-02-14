import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/repositories/service_civique_repository.dart';

//TODO(1418): à supprimer

class SearchServiceCiviqueAction {
  final Location? location;

  SearchServiceCiviqueAction({required this.location});
}

class ServiceCiviqueSearchFailureAction {
  final SearchServiceCiviqueRequest failedRequest;
  final List<ServiceCivique> previousOffers;

  ServiceCiviqueSearchFailureAction(this.failedRequest, this.previousOffers);
}

class ServiceCiviqueSearchResetAction {}

class RequestMoreServiceCiviqueSearchResultsAction {}

class RetryServiceCiviqueSearchAction {}

class ServiceCiviqueSearchSuccessAction {
  final ServiceCiviqueSearchResponse response;

  ServiceCiviqueSearchSuccessAction(this.response);
}

class ServiceCiviqueSearchUpdateFiltresAction {
  final int? distance;
  final DateTime? startDate;
  final Domaine? domain;

  ServiceCiviqueSearchUpdateFiltresAction({
    this.distance,
    this.startDate,
    this.domain,
  });
}

class ServiceCiviqueSavedSearchRequestAction {
  final ServiceCiviqueSavedSearch savedSearch;

  ServiceCiviqueSavedSearchRequestAction(this.savedSearch);
}
