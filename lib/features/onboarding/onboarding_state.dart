import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/onboarding.dart';

sealed class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingNotInitializedState extends OnboardingState {}

class OnboardingSuccessState extends OnboardingState {
  final Onboarding result;

  OnboardingSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
