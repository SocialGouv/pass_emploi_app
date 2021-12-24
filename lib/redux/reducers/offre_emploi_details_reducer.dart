import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/redux/reducers/reducer.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

class OffreEmploiDetailsReducer {
  final Reducer<OffreEmploiDetails> offreEmploiDetailsReducer = Reducer<OffreEmploiDetails>();

  State<OffreEmploiDetails> reduce(State<OffreEmploiDetails> currentState, OffreEmploiDetailsAction action) {
    if (action is OffreEmploiDetailsIncompleteDataAction) {
      return OffreEmploiDetailsIncompleteDataState(action.offre);
    } else {
      return offreEmploiDetailsReducer.reduce(currentState, action);
    }
  }
}
