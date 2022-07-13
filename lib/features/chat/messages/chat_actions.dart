import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';

class ChatRequestAction {}

class ChatLoadingAction {}

class ChatSuccessAction {
  final List<Message> messages;

  ChatSuccessAction(this.messages);
}

class ChatFailureAction {}

class ChatResetAction {}

class SendMessageAction {
  final String message;

  SendMessageAction(this.message);
}

class ChatPartagerOffreAction {
  final OffrePartagee offre;

  ChatPartagerOffreAction(this.offre);
}

class LastMessageSeenAction {}

class SubscribeToChatAction {}

class UnsubscribeFromChatAction {}
