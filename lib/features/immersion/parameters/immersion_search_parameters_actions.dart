import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';

class ImmersionSearchParametersRequestAction {
  final String codeRome;
  final Location location;
  final ImmersionSearchParametersFiltres filtres;

  ImmersionSearchParametersRequestAction({
    required this.codeRome,
    required this.location,
    required this.filtres,
  });
}

class ImmersionSearchUpdateFiltresRequestAction {
  final ImmersionSearchParametersFiltres updatedFiltres;

  ImmersionSearchUpdateFiltresRequestAction(this.updatedFiltres);
}

class ImmersionSearchWithUpdateFiltresSuccessAction {
  final List<Immersion> immersions;

  ImmersionSearchWithUpdateFiltresSuccessAction({required this.immersions});
}

class ImmersionSearchWithUpdateFiltresFailureAction {}
