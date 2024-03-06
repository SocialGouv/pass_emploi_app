import 'package:equatable/equatable.dart';

class Onboarding extends Equatable {
  final bool? showAccueilOnboarding;

  Onboarding({this.showAccueilOnboarding});

  factory Onboarding.initial() {
    return Onboarding(showAccueilOnboarding: true);
  }

  @override
  List<Object?> get props => [showAccueilOnboarding];

  factory Onboarding.fromJson(Map<String, dynamic> json) {
    return Onboarding(showAccueilOnboarding: json['showAccueilOnboarding'] as bool?);
  }

  Map<String, dynamic> toJson() {
    return {
      'showAccueilOnboarding': showAccueilOnboarding,
    };
  }

  Onboarding copyWith({bool? showAccueilOnboarding}) {
    return Onboarding(showAccueilOnboarding: showAccueilOnboarding ?? this.showAccueilOnboarding);
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
