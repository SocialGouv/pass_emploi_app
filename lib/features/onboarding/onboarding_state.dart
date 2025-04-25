import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/onboarding.dart';

sealed class OnboardingState extends Equatable {
  bool get showAccueilOnboarding => _onboarding?.showAccueilOnboarding == true;

  @override
  List<Object?> get props => [];

  Onboarding? get _onboarding => this is OnboardingSuccessState ? (this as OnboardingSuccessState).result : null;
}

class OnboardingNotInitializedState extends OnboardingState {}

class OnboardingSuccessState extends OnboardingState {
  final Onboarding result;

  OnboardingSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
