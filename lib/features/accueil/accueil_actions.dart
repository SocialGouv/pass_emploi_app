class AccueilRequestAction {}

class AccueilLoadingAction {}

class AccueilSuccessAction {
  final bool result;

  AccueilSuccessAction(this.result);
}

class AccueilFailureAction {}

class AccueilResetAction {}
