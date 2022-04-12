import 'package:pass_emploi_app/features/details_jeune/details_jeune_actions.dart';
import 'package:pass_emploi_app/features/details_jeune/details_jeune_state.dart';

DetailsJeuneState detailsJeuneReducer(DetailsJeuneState current, dynamic action) {
  if (action is DetailsJeuneLoadingAction) return DetailsJeuneLoadingState();
  if (action is DetailsJeuneSuccessAction) return DetailsJeuneSuccessState(detailsJeune: action.detailsJeune);
  if (action is DetailsJeuneFailureAction) return DetailsJeuneFailureState();
  return current;
}



