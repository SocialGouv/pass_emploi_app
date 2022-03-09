import 'package:pass_emploi_app/models/location.dart';

class SearchLocationRequestAction {
  final String? input;
  final bool villesOnly;

  SearchLocationRequestAction(this.input, {this.villesOnly = false});
}

class SearchLocationsSuccessAction {
  final List<Location> locations;

  SearchLocationsSuccessAction(this.locations);
}

class SearchLocationResetAction {}
