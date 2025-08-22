import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/feedback_activation.dart';

class InAppFeedbackState extends Equatable {
  final Map<String, FeedbackActivation> feedbackActivationForFeatures;

  InAppFeedbackState({this.feedbackActivationForFeatures = const {}});

  @override
  List<Object?> get props => [feedbackActivationForFeatures];
}
