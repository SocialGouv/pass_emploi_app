import 'package:pass_emploi_app/models/location.dart';

import '../../repositories/service_civique_repository.dart';

abstract class ServiceCiviqueAction {}

class SearchServiceCiviqueAction extends ServiceCiviqueAction {
  final Location? location;

  SearchServiceCiviqueAction({required this.location});
}

class ServiceCiviqueFailureAction extends ServiceCiviqueAction {}

class ServiceCiviqueSuccessAction extends ServiceCiviqueAction {
  final ServiceCiviqueSearchResponse response;

  ServiceCiviqueSuccessAction(this.response);
}
