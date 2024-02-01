import 'package:pass_emploi_app/repositories/cvm_repository.dart';

sealed class CvmAction {}

class CvmRequestAction extends CvmAction {}

class CvmLoadingAction extends CvmAction {}

class CvmSuccessAction extends CvmAction {
  final List<CvmEvent> messages;

  CvmSuccessAction(this.messages);
}

class CvmFailureAction extends CvmAction {}

class CvmResetAction extends CvmAction {}

class CvmSendMessageAction extends CvmAction {
  final String message;

  CvmSendMessageAction(this.message);
}

class CvmJoinRoomAction extends CvmAction {}
