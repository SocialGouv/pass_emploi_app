import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_state.dart';

FeatureFlipState featureFlipReducer(FeatureFlipState current, dynamic action) {
  if (action is FeatureFlipUseCvmAction) return FeatureFlipState(current.featureFlip.copyWith(useCvm: action.useCvm));
  if (action is FeatureFlipUsePjAction) return FeatureFlipState(current.featureFlip.copyWith(usePj: action.usePj));
  if (action is FeatureFlipOffresWordingABTestingAction) {
    return FeatureFlipState(current.featureFlip.copyWith(withOffresWording: action.withOffresWording));
  }
  if (action is FeatureFlipCampagneRecrutementAction) {
    return FeatureFlipState(current.featureFlip.copyWith(withCampagneRecrutement: action.withCampagneRecrutement));
  }
  return current;
}
