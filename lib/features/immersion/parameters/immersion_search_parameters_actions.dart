import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';

class ImmersionSearchParametersRequestAction {
  final SearchImmersionRequest request;

  ImmersionSearchParametersRequestAction({required this.request});
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
