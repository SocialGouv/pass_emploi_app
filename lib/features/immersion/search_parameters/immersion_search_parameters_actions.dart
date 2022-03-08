import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';

class ImmersionSearchWithFiltresAction {
  final ImmersionRequest request;
  final ImmersionSearchParametersFiltres filtres;

  ImmersionSearchWithFiltresAction({required this.request, required this.filtres});
}
