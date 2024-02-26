import 'package:pass_emploi_app/models/cvm/cvm_event.dart';

class CvmRequestAction {}

class CvmLoadingAction {}

class CvmSuccessAction {
  final List<CvmEvent> messages;

  CvmSuccessAction(this.messages);
}

class CvmFailureAction {}

class CvmSendMessageAction {
  final String message;

  CvmSendMessageAction(this.message);
}
