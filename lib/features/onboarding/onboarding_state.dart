import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/onboarding.dart';

class OnboardingState extends Equatable {
  final Onboarding? onboarding;

  final bool showMessageOnboarding;
  final bool showActionOnboarding;
  final bool showOffreOnboarding;
  final bool showEvenementOnboarding;
  final bool showOutilsOnboarding;

  OnboardingState({
    this.onboarding,
    this.showMessageOnboarding = false,
    this.showActionOnboarding = false,
    this.showOffreOnboarding = false,
    this.showEvenementOnboarding = false,
    this.showOutilsOnboarding = false,
  });

  @override
  List<Object?> get props => [
        onboarding,
        showMessageOnboarding,
        showActionOnboarding,
        showOffreOnboarding,
        showEvenementOnboarding,
        showOutilsOnboarding,
      ];

  OnboardingState copyWith({
    Onboarding? onboarding,
    bool? showMessageOnboarding,
    bool? showActionOnboarding,
    bool? showOffreOnboarding,
    bool? showEvenementOnboarding,
    bool? showOutilsOnboarding,
  }) {
    return OnboardingState(
      onboarding: onboarding ?? this.onboarding,
      showMessageOnboarding: showMessageOnboarding ?? this.showMessageOnboarding,
      showActionOnboarding: showActionOnboarding ?? this.showActionOnboarding,
      showOffreOnboarding: showOffreOnboarding ?? this.showOffreOnboarding,
      showEvenementOnboarding: showEvenementOnboarding ?? this.showEvenementOnboarding,
      showOutilsOnboarding: showOutilsOnboarding ?? this.showOutilsOnboarding,
    );
  }
}
