import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/offre_partagee.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:share_plus/share_plus.dart';

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

class SendImageAction {
  final XFile image;

  SendImageAction(this.image);
}

class DeleteMessageAction {
  final Message message;

  DeleteMessageAction(this.message);
}

class EditMessageAction {
  final Message message;
  final String newContent;

  EditMessageAction(this.message, this.newContent);
}

class ChatPartagerOffreAction {
  final OffrePartagee offre;

  ChatPartagerOffreAction(this.offre);
}

class ChatPartagerEventAction extends Equatable {
  final EventPartage eventPartage;

  ChatPartagerEventAction(this.eventPartage);

  @override
  List<Object?> get props => [eventPartage];
}

class ChatPartagerEvenementEmploiAction extends Equatable {
  final EvenementEmploiPartage evenementEmploi;

  ChatPartagerEvenementEmploiAction(this.evenementEmploi);

  @override
  List<Object?> get props => [evenementEmploi];
}

class ChatPartagerSessionMiloAction extends Equatable {
  final SessionMiloPartage sessionMilo;

  ChatPartagerSessionMiloAction(this.sessionMilo);

  @override
  List<Object?> get props => [sessionMilo];
}

class ChatRequestMorePastAction {}

class LastMessageSeenAction {}

class SubscribeToChatAction {}

class UnsubscribeFromChatAction {}
