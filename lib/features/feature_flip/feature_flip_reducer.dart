import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_state.dart';

FeatureFlipState featureFlipReducer(FeatureFlipState current, dynamic action) {
  if (action is FeatureFlipAction) {
    return FeatureFlipState(
      current.featureFlip.copyWith(
        useCvm: action.useCvm,
        withCampagneRecrutement: action.withCampagneRecrutement,
      ),
    );
  }
  return current;
}
