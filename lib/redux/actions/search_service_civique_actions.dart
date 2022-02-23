import 'package:pass_emploi_app/models/location.dart';

abstract class ServiceCiviqueAction {}

class SearchServiceCiviqueAction extends ServiceCiviqueAction {
  final Location? location;

  SearchServiceCiviqueAction({required this.location});
}

class ServiceCiviqueSuccessAction extends ServiceCiviqueAction {}
