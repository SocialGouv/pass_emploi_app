import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';

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

class ChatPartagerEventAction extends Equatable {
  final String id;
  final RendezvousType type;
  final String titre;
  final DateTime date;
  final String message;

  ChatPartagerEventAction({
    required this.id,
    required this.type,
    required this.titre,
    required this.date,
    required this.message,
  });

  @override
  List<Object?> get props => [id, type, titre, date, message];
}

class LastMessageSeenAction {}

class SubscribeToChatAction {}

class UnsubscribeFromChatAction {}
