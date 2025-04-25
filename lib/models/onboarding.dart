import 'package:equatable/equatable.dart';

class Onboarding extends Equatable {
  final bool showAccueilOnboarding;

  Onboarding({this.showAccueilOnboarding = true});

  factory Onboarding.initial() {
    return Onboarding(showAccueilOnboarding: true);
  }

  @override
  List<Object?> get props => [showAccueilOnboarding];

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    return Onboarding(showAccueilOnboarding: json['showAccueilOnboarding'] as bool? ?? true);
  }

  Map<String, dynamic> toJson() {
    return {'showAccueilOnboarding': showAccueilOnboarding};
  }

  Onboarding copyWith({
    bool? showAccueilOnboarding,
  }) {
    return Onboarding(
      showAccueilOnboarding: showAccueilOnboarding ?? this.showAccueilOnboarding,
    );
  }
}
