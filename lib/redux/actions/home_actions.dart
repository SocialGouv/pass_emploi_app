import 'package:pass_emploi_app/models/home.dart';

abstract class HomeAction {
  HomeAction._();

  factory HomeAction.loading() = HomeLoadingAction;

  factory HomeAction.success(Home home) = HomeSuccessAction;

  factory HomeAction.failure() = HomeFailureAction;
}

class HomeLoadingAction extends HomeAction {
  HomeLoadingAction() : super._();
}

class HomeSuccessAction extends HomeAction {
  final Home home;

  HomeSuccessAction(this.home) : super._();
}

class HomeFailureAction extends HomeAction {
  HomeFailureAction() : super._();
}
