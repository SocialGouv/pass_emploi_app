import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';

class OffreEmploiDetailsIncompleteDataAction extends OffreEmploiDetailsAction {
  final OffreEmploi offre;

  OffreEmploiDetailsIncompleteDataAction(this.offre);
}
