import 'dart:async';

import 'package:pass_emploi_app/features/chat/messages/chat_history_aggregator.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';

abstract class ChatSuperRepository {
  Stream<List<Message>> startMessagesStream();
  void pauseMessagesStream();
  void resetMessageStream();
  Future<void> loadOldMessages();
  Future<bool> sendMessage(String messageText);

  Future<bool> sendOffrePartagee(OffrePartagee offre);
  Future<bool> sendEventPartage(EventPartage evenementEmploi);
  Future<bool> sendSessionMiloPartage(SessionMiloPartage eventPartage);
  Future<bool> sendEvenementEmploiPartage(EvenementEmploiPartage sessionMilo);

  // Stream<ConseillerMessageInfo> chatStatusStream();
  Future<void> setLastMessageSeen();
}

class FirebaseChatSuperRepository implements ChatSuperRepository {
  final ChatRepository _repository;
  final String userId;
  final ChatHistoryAggregator _chatHistoryAggregator = ChatHistoryAggregator();
  final StreamController<List<Message>> _messagesController = StreamController.broadcast();

  StreamSubscription<List<Message>>? _subscription;

  FirebaseChatSuperRepository({required ChatRepository repository, required this.userId}) : _repository = repository;

  @override
  void resetMessageStream() {
    _chatHistoryAggregator.reset();
    _messagesController.add(_chatHistoryAggregator.messages);
  }

  @override
  Stream<List<Message>> startMessagesStream() {
    _subscription = _repository.messagesStream(userId).listen((messages) {
      _chatHistoryAggregator.onNewMessages(messages);
      _messagesController.add(_chatHistoryAggregator.messages);
    });
    return _messagesController.stream;
  }

  @override
  void pauseMessagesStream() {
    _subscription?.cancel();
  }

  @override
  Future<void> loadOldMessages() async {
    if (_chatHistoryAggregator.historyEnded) return;

    final oldestMessageDate = _chatHistoryAggregator.oldestMessageDate();
    if (oldestMessageDate == null) return;

    final messages = await _repository.oldMessages(userId, oldestMessageDate);
    _chatHistoryAggregator.onOldMessages(messages, _repository.numberOfHistoryMessage);
    _messagesController.add(_chatHistoryAggregator.messages);
  }

  @override
  Future<bool> sendMessage(String messageText) async {
    final message = Message.fromText(messageText);
    // Delayed to show the sending message animation
    _chatHistoryAggregator.addMessage(message);
    return Future.delayed(AnimationDurations.slow, () async {
      final sendMessageSuceed = await _repository.sendMessage(userId, message);
      if (!sendMessageSuceed) {
        final failedMessage = message.copyWith(status: MessageStatus.failed);
        _chatHistoryAggregator.addMessage(failedMessage);
      }
      return sendMessageSuceed;
    });
  }

  @override
  Future<bool> sendOffrePartagee(OffrePartagee offre) {
    return _repository.sendOffrePartagee(userId, offre);
  }

  @override
  Future<bool> sendEventPartage(EventPartage evenementEmploi) {
    return _repository.sendEventPartage(userId, evenementEmploi);
  }

  @override
  Future<bool> sendSessionMiloPartage(SessionMiloPartage eventPartage) {
    return _repository.sendSessionMiloPartage(userId, eventPartage);
  }

  @override
  Future<bool> sendEvenementEmploiPartage(EvenementEmploiPartage sessionMilo) {
    return _repository.sendEvenementEmploiPartage(userId, sessionMilo);
  }

  @override
  Future<void> setLastMessageSeen() {
    return _repository.setLastMessageSeen(userId);
  }

  // Stream<ConseillerMessageInfo> chatStatusStream
}

class CvmChatSuperRepository implements ChatSuperRepository {
  CvmChatSuperRepository({required CvmRepository repository}) : _repository = repository;
  StreamSubscription<List<CvmEvent>>? _subscription;
  final CvmChatAggregator _chatAggregator = CvmChatAggregator();
  final StreamController<List<Message>> _messagesController = StreamController.broadcast();

  final CvmRepository _repository;

  @override
  void resetMessageStream() {
    _messagesController.add([]);
  }

  @override
  void pauseMessagesStream() {
    _subscription?.cancel();
  }

  @override
  Stream<List<Message>> startMessagesStream() {
    _subscription = _repository.getMessages().listen((events) {
      final messages = events.map((event) => event.toMessage).toList();
      _chatAggregator.onRemoteMessages(messages);
      _messagesController.add(_chatAggregator.messages);
    });
    return _messagesController.stream;
  }

  @override
  Future<void> loadOldMessages() async {
    await _repository.loadMore();
  }

  @override
  Future<bool> sendMessage(String messageText) async {
    final message = Message.fromText(messageText);
    _chatAggregator.onLocalMessages(message);
    final result = await _repository.sendMessage(messageText);
    if (!result) {
      _chatAggregator.onMessageFailure(message);
    }
    return result;
  }

  @override
  Future<bool> sendOffrePartagee(OffrePartagee offre) {
    const messageText = "Offre partagée";
    return sendMessage(messageText);
  }

  @override
  Future<bool> sendEventPartage(EventPartage evenementEmploi) {
    const messageText = "Evenement partagé";
    return sendMessage(messageText);
  }

  @override
  Future<bool> sendSessionMiloPartage(SessionMiloPartage eventPartage) {
    const messageText = "Session Milo partagée";
    return sendMessage(messageText);
  }

  @override
  Future<bool> sendEvenementEmploiPartage(EvenementEmploiPartage sessionMilo) {
    const messageText = "Evenement Emploi partagé";
    return sendMessage(messageText);
  }

  // Stream<ConseillerMessageInfo> chatStatusStream // TODO: => Diviser en deux streams

  @override
  Future<void> setLastMessageSeen() {
    return Future.value(); // pas trouvé d'équivalent natif
  }
}

class CvmChatAggregator {
  final List<Message> _remoteMessages = [];
  final List<Message> _localMessages = [];

  List<Message> get messages => [..._remoteMessages, ..._localMessages];

  void onRemoteMessages(List<Message> newMessages) {
    final myLastRemoteMessageDate = _localMessages.lastOrNull?.creationDate;

    if (myLastRemoteMessageDate != null) {
      newMessages = newMessages
          .where((message) => message.creationDate.isAfter(myLastRemoteMessageDate) && message.sentBy == Sender.jeune)
          .toList();
    }

    _remoteMessages.addAll(newMessages);
  }

  void onLocalMessages(Message newMessage) {
    _localMessages.add(newMessage);
  }

  void onMessageFailure(Message failedMessage) {
    _localMessages.removeWhere((message) => message.id == failedMessage.id);
    _localMessages.add(failedMessage);
  }
}
