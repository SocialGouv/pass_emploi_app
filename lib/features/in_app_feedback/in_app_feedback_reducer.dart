import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_actions.dart';
import 'package:pass_emploi_app/features/in_app_feedback/in_app_feedback_state.dart';
import 'package:pass_emploi_app/models/feedback_activation.dart';

InAppFeedbackState inAppFeedbackReducer(InAppFeedbackState current, dynamic action) {
  if (action is InAppFeedbackSuccessAction) {
    final copy = Map<String, FeedbackActivation>.from(current.feedbackActivationForFeatures);
    copy[action.feedbackActivationForFeature.key] = action.feedbackActivationForFeature.value;
    return InAppFeedbackState(feedbackActivationForFeatures: copy);
  }
  if (action is InAppFeedbackDismissAction) {
    final copy = Map<String, FeedbackActivation>.from(current.feedbackActivationForFeatures);
    copy[action.feature] = FeedbackActivation(
      isActivated: false,
      commentaireEnabled: false,
      dismissable: true,
    );
    return InAppFeedbackState(feedbackActivationForFeatures: copy);
  }
  return current;
}
