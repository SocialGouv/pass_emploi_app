import 'package:pass_emploi_app/models/location.dart';

abstract class SearchLocationAction {}

class RequestLocationAction extends SearchLocationAction {
  final String? input;
  final bool villesOnly;

  RequestLocationAction(this.input, {this.villesOnly = false});
}

class SearchLocationsSuccessAction extends SearchLocationAction {
  final List<Location> locations;

  SearchLocationsSuccessAction(this.locations);
}

class ResetLocationAction extends SearchLocationAction {}
