import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';

class ImmersionListRequestAction {
  final String codeRome;
  final Location location;
  final String? title;

  ImmersionListRequestAction(this.codeRome, this.location, [this.title]);
}

class ImmersionListLoadingAction {}

class ImmersionListSuccessAction {
  final List<Immersion> immersions;

  ImmersionListSuccessAction(this.immersions);
}

class ImmersionListFailureAction {}

class ImmersionListResetAction {}

class SavedImmersionSearchRequestAction {
  final String codeRome;
  final Location location;
  final ImmersionSearchParametersFiltres filtres;

  SavedImmersionSearchRequestAction({
    required this.codeRome,
    required this.location,
    required this.filtres,
  });
}
