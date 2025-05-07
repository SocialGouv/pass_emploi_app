import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/onboarding.dart';

sealed class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

// TODO: Supprimer le not initialized state et garder qu'un seul state
class OnboardingNotInitializedState extends OnboardingState {}

class OnboardingSuccessState extends OnboardingState {
  final Onboarding onboarding;

  OnboardingSuccessState(this.onboarding);

  @override
  List<Object?> get props => [onboarding];
}
