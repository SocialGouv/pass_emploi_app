import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_actions.dart';
import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_state.dart';

InAppFeedbackState inAppFeedbackReducer(InAppFeedbackState current, dynamic action) {
  if (action is InAppFeedbackSuccessAction) {
    final copy = Map<String, bool>.from(current.feedbackActivationForFeatures);
    copy[action.feedbackActivationForFeature.key] = action.feedbackActivationForFeature.value;
    return InAppFeedbackState(feedbackActivationForFeatures: copy);
  }
  if (action is InAppFeedbackDismissAction) {
    final copy = Map<String, bool>.from(current.feedbackActivationForFeatures);
    copy[action.feature] = false;
    return InAppFeedbackState(feedbackActivationForFeatures: copy);
  }
  return current;
}
