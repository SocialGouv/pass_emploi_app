class InAppFeedbackRequestAction {
  final String feature;

  InAppFeedbackRequestAction(this.feature);
}

class InAppFeedbackDismissAction {
  final String feature;

  InAppFeedbackDismissAction(this.feature);
}

class InAppFeedbackSuccessAction {
  final MapEntry<String, bool> feedbackActivationForFeature;

  InAppFeedbackSuccessAction(this.feedbackActivationForFeature);
}
