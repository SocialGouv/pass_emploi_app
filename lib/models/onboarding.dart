import 'package:equatable/equatable.dart';

class Onboarding extends Equatable {
  final bool showAccueilOnboarding;
  final bool showMonSuiviOnboarding;
  final bool showChatOnboarding;
  final bool showRechercheOnboarding;
  final bool showEvenementsOnboarding;

  Onboarding({
    this.showAccueilOnboarding = true,
    this.showMonSuiviOnboarding = true,
    this.showChatOnboarding = true,
    this.showRechercheOnboarding = true,
    this.showEvenementsOnboarding = true,
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
      showAccueilOnboarding: json['showAccueilOnboarding'] as bool? ?? true,
      showMonSuiviOnboarding: json['showMonSuiviOnboarding'] as bool? ?? true,
      showChatOnboarding: json['showChatOnboarding'] as bool? ?? true,
      showRechercheOnboarding: json['showRechercheOnboarding'] as bool? ?? true,
      showEvenementsOnboarding: json['showEvenementsOnboarding'] as bool? ?? true,
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
