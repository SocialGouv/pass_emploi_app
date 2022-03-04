import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';

import 'named_actions.dart';

class ImmersionSearchUpdateFiltresAction extends ImmersionAction {
  final ImmersionSearchParametersFiltres updatedFiltres;

  ImmersionSearchUpdateFiltresAction(this.updatedFiltres);
}

class ImmersionSearchWithUpdateFiltresSuccessAction extends ImmersionAction {
  final List<Immersion> immersions;

  ImmersionSearchWithUpdateFiltresSuccessAction({required this.immersions});
}

class ImmersionSearchWithUpdateFiltresFailureAction extends ImmersionAction {}
