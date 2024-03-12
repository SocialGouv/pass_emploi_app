import 'package:pass_emploi_app/features/campagne_recrutement/campagne_recrutement_actions.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_state.dart';

FeatureFlipState featureFlipReducer(FeatureFlipState current, dynamic action) {
  if (action is FeatureFlipAction) return FeatureFlipState(action.featureFlip);
  if (action is CampagneRecrutementDismissAction) {
    return FeatureFlipState(current.featureFlip.copyWith(withCampagneRecrutement: false));
  }
  return current;
}
