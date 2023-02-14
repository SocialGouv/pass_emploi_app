import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';

class ImmersionSearchUpdateFiltresRequestAction {
  final ImmersionFiltresRecherche updatedFiltres;

  ImmersionSearchUpdateFiltresRequestAction(this.updatedFiltres);
}

class ImmersionSearchWithUpdateFiltresSuccessAction {
  final List<Immersion> immersions;

  ImmersionSearchWithUpdateFiltresSuccessAction({required this.immersions});
}

class ImmersionSearchWithUpdateFiltresFailureAction {}
