import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';

class ImmersionSearchUpdateFiltresAction {
  final ImmersionSearchParametersFiltres updatedFiltres;

  ImmersionSearchUpdateFiltresAction(this.updatedFiltres);
}

class ImmersionSearchWithUpdateFiltresSuccessAction {
  final List<Immersion> immersions;

  ImmersionSearchWithUpdateFiltresSuccessAction({required this.immersions});
}

class ImmersionSearchWithUpdateFiltresFailureAction {}
