import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/onboarding.dart';

sealed class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];

  bool get isSuccessState => this is OnboardingSuccessState;

  bool get showAccueilOnboarding =>
      isSuccessState && (this as OnboardingSuccessState).result.showAccueilOnboarding == true;
  bool get showMonSuiviOnboarding =>
      isSuccessState && (this as OnboardingSuccessState).result.showMonSuiviOnboarding == true;
  bool get showChatOnboarding => isSuccessState && (this as OnboardingSuccessState).result.showChatOnboarding == true;
  bool get showRechercheOnboarding =>
      isSuccessState && (this as OnboardingSuccessState).result.showRechercheOnboarding == true;
  bool get showEvenementsOnboarding =>
      isSuccessState && (this as OnboardingSuccessState).result.showEvenementsOnboarding == true;
}

class OnboardingNotInitializedState extends OnboardingState {}

class OnboardingSuccessState extends OnboardingState {
  final Onboarding result;

  OnboardingSuccessState(this.result);

  @override
  List<Object?> get props => [result];
}
