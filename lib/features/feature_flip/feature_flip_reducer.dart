import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_state.dart';

FeatureFlipState featureFlipReducer(FeatureFlipState current, dynamic action) {
  if (action is FeatureFlipUseCvmAction) return FeatureFlipState(current.featureFlip.copyWith(useCvm: action.useCvm));
  if (action is FeatureFlipCjeAction) return FeatureFlipState(current.featureFlip.copyWith(withCje: action.withCje));
  if (action is FeatureFlipCampagneRecrutementAction) {
    return FeatureFlipState(current.featureFlip.copyWith(withCampagneRecrutement: action.withCampagneRecrutement));
  }
  return current;
}
