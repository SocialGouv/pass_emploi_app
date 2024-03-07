import 'package:equatable/equatable.dart';

class Onboarding extends Equatable {
  final bool? showAccueilOnboarding;
  final bool? showMonSuiviOnboarding;
  final bool? showChatOnboarding;
  final bool? showRechercheOnboarding;
  final bool? showEvenementsOnboarding;

  Onboarding({
    this.showAccueilOnboarding,
    this.showMonSuiviOnboarding,
    this.showChatOnboarding,
    this.showRechercheOnboarding,
    this.showEvenementsOnboarding,
  });

  factory Onboarding.initial() {
    return Onboarding(
      showAccueilOnboarding: true,
      showMonSuiviOnboarding: true,
      showChatOnboarding: true,
      showRechercheOnboarding: true,
      showEvenementsOnboarding: true,
    );
  }

  @override
  List<Object?> get props => [
        showAccueilOnboarding,
        showMonSuiviOnboarding,
        showChatOnboarding,
        showRechercheOnboarding,
        showEvenementsOnboarding,
      ];

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    return Onboarding(
      showAccueilOnboarding: json['showAccueilOnboarding'] as bool?,
      showMonSuiviOnboarding: json['showMonSuiviOnboarding'] as bool?,
      showChatOnboarding: json['showChatOnboarding'] as bool?,
      showRechercheOnboarding: json['showRechercheOnboarding'] as bool?,
      showEvenementsOnboarding: json['showEvenementsOnboarding'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showAccueilOnboarding': showAccueilOnboarding,
      'showMonSuiviOnboarding': showMonSuiviOnboarding,
      'showChatOnboarding': showChatOnboarding,
      'showRechercheOnboarding': showRechercheOnboarding,
      'showEvenementsOnboarding': showEvenementsOnboarding,
    };
  }

  Onboarding copyWith({
    bool? showAccueilOnboarding,
    bool? showMonSuiviOnboarding,
    bool? showChatOnboarding,
    bool? showRechercheOnboarding,
    bool? showEvenementsOnboarding,
  }) {
    return Onboarding(
      showAccueilOnboarding: showAccueilOnboarding ?? this.showAccueilOnboarding,
      showMonSuiviOnboarding: showMonSuiviOnboarding ?? this.showMonSuiviOnboarding,
      showChatOnboarding: showChatOnboarding ?? this.showChatOnboarding,
      showRechercheOnboarding: showRechercheOnboarding ?? this.showRechercheOnboarding,
      showEvenementsOnboarding: showEvenementsOnboarding ?? this.showEvenementsOnboarding,
    );
  }
}

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
