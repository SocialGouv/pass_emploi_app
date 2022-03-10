import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';

class ImmersionSearchWithFiltresAction {
  final SearchImmersionRequest request;
  final ImmersionSearchParametersFiltres filtres;

  ImmersionSearchWithFiltresAction({required this.request, required this.filtres});
}
