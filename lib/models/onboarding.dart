import 'package:equatable/equatable.dart';

class Onboarding extends Equatable {
  final bool _showAccueilOnboardingLegacy;

  final bool showNotificationsOnboarding;
  final bool showOnboarding;

  final bool messageCompleted;
  final bool actionCompleted;
  final bool offreCompleted;
  final bool evenementCompleted;
  final bool outilsCompleted;

  Onboarding({
    bool showAccueilOnboardingLegacy = true,
    bool? showNotificationsOnboarding,
    bool? showOnboarding,
    this.messageCompleted = false,
    this.actionCompleted = false,
    this.offreCompleted = false,
    this.evenementCompleted = false,
    this.outilsCompleted = false,
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
        messageCompleted,
        actionCompleted,
        offreCompleted,
        evenementCompleted,
        outilsCompleted,
      ];

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    final showAccueilOnboarding = json['showAccueilOnboarding'] as bool? ?? true;

    return Onboarding(
      showAccueilOnboardingLegacy: showAccueilOnboarding,
      showNotificationsOnboarding: json['showNotificationsOnboarding'] as bool?,
      showOnboarding: json['showOnboarding'] as bool?,
      messageCompleted: json['messageCompleted'] as bool? ?? false,
      actionCompleted: json['actionCompleted'] as bool? ?? false,
      offreCompleted: json['offreCompleted'] as bool? ?? false,
      evenementCompleted: json['evenementCompleted'] as bool? ?? false,
      outilsCompleted: json['outilsCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showAccueilOnboarding': _showAccueilOnboardingLegacy,
      'showNotificationsOnboarding': showNotificationsOnboarding,
      'showOnboarding': showOnboarding,
      'messageCompleted': messageCompleted,
      'actionCompleted': actionCompleted,
      'offreCompleted': offreCompleted,
      'evenementCompleted': evenementCompleted,
      'outilsCompleted': outilsCompleted,
    };
  }

  Onboarding copyWith({
    bool? showNotificationsOnboarding,
    bool? showOnboarding,
    bool? messageCompleted,
    bool? actionCompleted,
    bool? offreCompleted,
    bool? evenementCompleted,
    bool? outilsCompleted,
  }) {
    return Onboarding(
      showAccueilOnboardingLegacy: _showAccueilOnboardingLegacy,
      showNotificationsOnboarding: showNotificationsOnboarding ?? this.showNotificationsOnboarding,
      showOnboarding: showOnboarding ?? this.showOnboarding,
      messageCompleted: messageCompleted ?? this.messageCompleted,
      actionCompleted: actionCompleted ?? this.actionCompleted,
      offreCompleted: offreCompleted ?? this.offreCompleted,
      evenementCompleted: evenementCompleted ?? this.evenementCompleted,
      outilsCompleted: outilsCompleted ?? this.outilsCompleted,
    );
  }
}

extension OnboardingExtension on Onboarding {
  int completedSteps() =>
      [
        messageCompleted,
        actionCompleted,
        offreCompleted,
        evenementCompleted,
        outilsCompleted,
      ].where((step) => step).length +
      1;

  int totalSteps() => 6;
}
