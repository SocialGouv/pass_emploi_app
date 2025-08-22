import 'package:equatable/equatable.dart';

class FeedbackActivation extends Equatable {
  final bool isActivated;
  final bool commentaireEnabled;

  FeedbackActivation({required this.isActivated, required this.commentaireEnabled});

  @override
  List<Object?> get props => [isActivated, commentaireEnabled];
}
