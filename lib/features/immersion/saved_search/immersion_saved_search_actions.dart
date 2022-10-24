import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';

class ImmersionSavedSearchRequestAction {
  final String codeRome;
  final Location? location;
  final ImmersionSearchParametersFiltres filtres;

  ImmersionSavedSearchRequestAction({
    required this.codeRome,
    required this.location,
    required this.filtres,
  });

  factory ImmersionSavedSearchRequestAction.fromSearch(ImmersionSavedSearch search) {
    return ImmersionSavedSearchRequestAction(
      codeRome: search.codeRome,
      location: search.location,
      filtres: search.filtres,
    );
  }
}
