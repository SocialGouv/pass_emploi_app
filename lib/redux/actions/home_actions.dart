import 'package:pass_emploi_app/models/home.dart';

abstract class HomeAction {}

class HomeLoadingAction extends HomeAction {}

class HomeSuccessAction extends HomeAction {
  final Home home;

  HomeSuccessAction(this.home);
}

class HomeFailureAction extends HomeAction {}
