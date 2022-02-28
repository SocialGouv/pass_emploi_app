import 'package:pass_emploi_app/models/location.dart';

import '../../../repositories/service_civique_repository.dart';

class SearchServiceCiviqueAction {
  final Location? location;

  SearchServiceCiviqueAction({required this.location});
}

class ServiceCiviqueSearchFailureAction {}

class ServiceCiviqueSearchResetAction {}

class RequestMoreServiceCiviqueSearchResultsAction {}

class ServiceCiviqueSearchSuccessAction {
  final ServiceCiviqueSearchResponse response;

  ServiceCiviqueSearchSuccessAction(this.response);
}
