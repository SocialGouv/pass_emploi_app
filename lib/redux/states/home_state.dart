import 'package:pass_emploi_app/models/home.dart';

abstract class HomeState {
  HomeState._();

  factory HomeState.loading() = HomeLoadingState;

  factory HomeState.success(Home home) = HomeSuccessState;

  factory HomeState.failure() = HomeFailureState;

  factory HomeState.notInitialized() = HomeNotInitializedState;
}

class HomeLoadingState extends HomeState {
  HomeLoadingState() : super._();
}

class HomeSuccessState extends HomeState {
  final Home home;

  HomeSuccessState(this.home) : super._();
}

class HomeFailureState extends HomeState {
  HomeFailureState() : super._();
}

class HomeNotInitializedState extends HomeState {
  HomeNotInitializedState() : super._();
}
