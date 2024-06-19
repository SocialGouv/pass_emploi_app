import 'package:pass_emploi_app/models/chat/cvm_message.dart';

class CvmRequestAction {}

class CvmLoadingAction {}

class CvmSuccessAction {
  final List<CvmMessage> messages;

  CvmSuccessAction(this.messages);
}

class CvmFailureAction {}

class CvmResetAction {}

class CvmLastJeuneReadingAction {}

class CvmSendMessageAction {
  final String message;

  CvmSendMessageAction(this.message);
}

class CvmLoadMoreAction {}
