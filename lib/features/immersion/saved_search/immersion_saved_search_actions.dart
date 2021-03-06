import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';

class ImmersionSavedSearchRequestAction {
  final String codeRome;
  final Location? location;
  final ImmersionSearchParametersFiltres filtres;

  ImmersionSavedSearchRequestAction({
    required this.codeRome,
    required this.location,
    required this.filtres,
  });
}
