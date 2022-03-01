import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';

class GetServiceCiviqueDetailAction {
  final String id;

  GetServiceCiviqueDetailAction(this.id);
}

class ServiceCiviqueDetailLoadingAction {}

class ServiceCiviqueDetailFailureAction {}

class ServiceCiviqueDetailSuccessAction {
  final ServiceCiviqueDetail detail;

  ServiceCiviqueDetailSuccessAction(this.detail);
}
