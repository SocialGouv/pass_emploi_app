import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';

class CreateDemarcheBatchRequestAction {
  final List<CreateDemarcheRequestAction> actions;

  CreateDemarcheBatchRequestAction(this.actions);
}

class CreateDemarcheBatchLoadingAction {}

class CreateDemarcheBatchSuccessAction {}

class CreateDemarcheBatchFailureAction {}

class CreateDemarcheBatchResetAction {}
