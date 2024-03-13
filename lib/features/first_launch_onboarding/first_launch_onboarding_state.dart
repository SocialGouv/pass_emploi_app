import 'package:equatable/equatable.dart';

sealed class FirstLaunchOnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FirstLaunchOnboardingNotInitializedState extends FirstLaunchOnboardingState {}

class FirstLaunchOnboardingSuccessState extends FirstLaunchOnboardingState {
  final bool showOnboarding;

  FirstLaunchOnboardingSuccessState(this.showOnboarding);

  @override
  List<Object?> get props => [showOnboarding];
}
