import 'package:pass_emploi_app/models/feedback_activation.dart';

class InAppFeedbackRequestAction {
  final String feature;

  InAppFeedbackRequestAction(this.feature);
}

class InAppFeedbackDismissAction {
  final String feature;

  InAppFeedbackDismissAction(this.feature);
}

class InAppFeedbackSuccessAction {
  final MapEntry<String, FeedbackActivation> feedbackActivationForFeature;

  InAppFeedbackSuccessAction(this.feedbackActivationForFeature);
}
