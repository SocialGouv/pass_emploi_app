import 'package:equatable/equatable.dart';

class Onboarding extends Equatable {
  final bool _showAccueilOnboardingLegacy;

  final bool showNotificationsOnboarding;
  final bool showOnboarding;

  Onboarding({
    bool showAccueilOnboardingLegacy = true,
    bool? showNotificationsOnboarding,
    bool? showOnboarding,
  })  : _showAccueilOnboardingLegacy = showAccueilOnboardingLegacy,
        showNotificationsOnboarding = showAccueilOnboardingLegacy ? (showNotificationsOnboarding ?? true) : false,
        showOnboarding = showAccueilOnboardingLegacy ? (showOnboarding ?? true) : false;

  factory Onboarding.initial() {
    return Onboarding();
  }

  @override
  List<Object?> get props => [
        _showAccueilOnboardingLegacy,
        showNotificationsOnboarding,
        showOnboarding,
      ];

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    final showAccueilOnboarding = json['showAccueilOnboarding'] as bool? ?? true;

    return Onboarding(
      showAccueilOnboardingLegacy: showAccueilOnboarding,
      showNotificationsOnboarding: json['showNotificationsOnboarding'] as bool?,
      showOnboarding: json['showOnboarding'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showAccueilOnboarding': _showAccueilOnboardingLegacy,
      'showNotificationsOnboarding': showNotificationsOnboarding,
      'showOnboarding': showOnboarding,
    };
  }

  Onboarding copyWith({
    bool? showNotificationsOnboarding,
    bool? showOnboarding,
  }) {
    return Onboarding(
      showAccueilOnboardingLegacy: _showAccueilOnboardingLegacy,
      showNotificationsOnboarding: showNotificationsOnboarding ?? this.showNotificationsOnboarding,
      showOnboarding: showOnboarding ?? this.showOnboarding,
    );
  }
}
