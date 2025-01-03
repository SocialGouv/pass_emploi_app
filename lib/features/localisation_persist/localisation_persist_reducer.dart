import 'package:pass_emploi_app/features/localisation_persist/localisation_persist_actions.dart';
import 'package:pass_emploi_app/features/localisation_persist/localisation_persist_state.dart';

LocalisationPersistState localisationPersistReducer(LocalisationPersistState current, dynamic action) {
  if (action is LocalisationPersistSuccessAction) return LocalisationPersistSuccessState(action.result);
  return current;
}
