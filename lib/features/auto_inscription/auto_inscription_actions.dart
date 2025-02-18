import 'package:pass_emploi_app/repositories/auto_inscription_repository.dart';

class AutoInscriptionRequestAction {
  final String eventId;

  AutoInscriptionRequestAction({required this.eventId});
}

class AutoInscriptionLoadingAction {}

class AutoInscriptionSuccessAction {
  AutoInscriptionSuccessAction();
}

class AutoInscriptionFailureAction {
  final AutoInscriptionError error;

  AutoInscriptionFailureAction({required this.error});
}
