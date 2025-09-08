import 'package:equatable/equatable.dart';

class FeedbackActivation extends Equatable {
  final bool isActivated;
  final bool commentaireEnabled;
  final bool dismissable;

  FeedbackActivation({required this.isActivated, required this.commentaireEnabled, required this.dismissable});

  @override
  List<Object?> get props => [isActivated, commentaireEnabled, dismissable];
}
