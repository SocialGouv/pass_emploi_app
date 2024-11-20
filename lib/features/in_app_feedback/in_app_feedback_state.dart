import 'package:equatable/equatable.dart';

class InAppFeedbackState extends Equatable {
  final Map<String, bool> feedbackActivationForFeatures;

  InAppFeedbackState({this.feedbackActivationForFeatures = const {}});

  @override
  List<Object?> get props => [feedbackActivationForFeatures];
}
