import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_history_aggregator.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_chat_repository.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/offre_partagee.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:redux/redux.dart';

class ChatMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _repository;
  StreamSubscription<List<Message>>? _subscription;
  final ChatHistoryAggregator _chatHistoryAggregator = ChatHistoryAggregator();

  ChatMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is LoginSuccessAction || action is RequestLogoutAction || action is NotLoggedInAction) {
      _chatHistoryAggregator.reset();
    }
    if (loginState is LoginSuccessState) {
      final userId = loginState.user.id;
      if (action is SubscribeToChatAction) {
        if (loginState.user.loginMode == LoginMode.DEMO_MILO || loginState.user.loginMode == LoginMode.DEMO_PE) {
          store.dispatch(ChatSuccessAction(modeDemoChat()));
        } else {
          _displayLoaderOnFirstTimeAndCurrentMessagesAfter(store);
          _subscribeToChatStream(userId, store);
        }
      } else if (!loginState.user.loginMode.isDemo()) {
        if (action is UnsubscribeFromChatAction) {
          _subscription?.cancel();
        } else if (action is SendMessageAction) {
          _sendMessage(store, userId, action.message);
        } else if (action is DeleteMessageAction) {
          _deleteMessage(store, userId, action.message);
        } else if (action is SendImageAction) {
          _sendImage(store, userId, action.image);
        } else if (action is EditMessageAction) {
          _editMessage(store, userId, action.message, action.newContent);
        } else if (action is ChatPartagerOffreAction) {
          _partagerOffre(store, userId, action.offre);
        } else if (action is ChatPartagerEventAction) {
          _partagerEvent(store, userId, action.eventPartage);
        } else if (action is ChatPartagerEvenementEmploiAction) {
          _partagerEvenementEmploi(store, userId, action.evenementEmploi);
        } else if (action is ChatPartagerSessionMiloAction) {
          _partageSessionMilo(store, userId, action.sessionMilo);
        } else if (action is LastMessageSeenAction) {
          _repository.setLastMessageSeen(userId);
        } else if (action is ChatRequestMorePastAction) {
          _loadOldMessages(userId, store);
        }
      }
    }
  }

  void _sendMessage(Store<AppState> store, String userId, String messageText) async {
    final message = Message.fromText(messageText);
    _addMessageToLocal(store, message);
    // Delayed to show the sending message animation
    Future.delayed(AnimationDurations.slow, () => _addMessageToRemote(store, userId, message));
  }

  void _deleteMessage(Store<AppState> store, String userId, Message message) async {
    final chatState = store.state.chatState;
    final bool isLastMessage = chatState is ChatSuccessState && (chatState.messages.last.id == message.id);
    _repository.deleteMessage(userId, message, isLastMessage);
  }

  void _sendImage(Store<AppState> store, String userId, XFile image) async {
    final message = Message.fromImage(image);
    _addMessageToLocal(store, message);
    // TODO: Implement image sending
  }

  void _editMessage(Store<AppState> store, String userId, Message message, String content) async {
    final chatState = store.state.chatState;
    final bool isLastMessage = chatState is ChatSuccessState && (chatState.messages.last.id == message.id);
    _repository.editMessage(userId, message, isLastMessage, content);
  }

  Future<void> _addMessageToRemote(Store<AppState> store, String userId, Message message) async {
    final sendMessageSuceed = await _repository.sendMessage(userId, message);
    if (!sendMessageSuceed) {
      _addMessageToLocal(store, message.copyWith(sendingStatus: MessageSendingStatus.failed));
    }
  }

  void _partagerOffre(Store<AppState> store, String userId, OffrePartagee offre) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _repository.sendOffrePartagee(userId, offre);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.MESSAGE_OFFRE_PARTAGEE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partagerEvenementEmploi(Store<AppState> store, String userId, EvenementEmploiPartage evenementEmploi) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _repository.sendEvenementEmploiPartage(userId, evenementEmploi);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.EVENEMENT_EXTERNE_PARTAGE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partagerEvent(Store<AppState> store, String userId, EventPartage eventPartage) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _repository.sendEventPartage(userId, eventPartage);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.ANIMATION_COLLECTIVE_PARTAGEE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partageSessionMilo(Store<AppState> store, String userId, SessionMiloPartage sessionMilo) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _repository.sendSessionMiloPartage(userId, sessionMilo);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.MESSAGE_SESSION_MILO_PARTAGE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _displayLoaderOnFirstTimeAndCurrentMessagesAfter(Store<AppState> store) {
    final currentChatState = store.state.chatState;
    if (currentChatState is ChatSuccessState) {
      store.dispatch(ChatSuccessAction(currentChatState.messages));
    } else {
      store.dispatch(ChatLoadingAction());
    }
  }

  void _subscribeToChatStream(String userId, Store<AppState> store) {
    _subscription = _repository.messagesStream(userId).listen(
      (messages) {
        _chatHistoryAggregator.onNewMessages(messages);
        _dispatchAllMessages(store);
      },
      onError: (Object error) {
        if (error is ChatNotInitializedError) {
          store.dispatch(TryConnectChatAgainAction());
        }
        return store.dispatch(ChatFailureAction());
      },
    );
  }

  void _loadOldMessages(String userId, Store<AppState> store) async {
    if (_chatHistoryAggregator.historyEnded) return;

    final oldestMessageDate = _chatHistoryAggregator.oldestMessageDate();
    if (oldestMessageDate == null) return;

    final messages = await _repository.oldMessages(userId, oldestMessageDate);
    _chatHistoryAggregator.onOldMessages(messages, _repository.numberOfHistoryMessage);
    _dispatchAllMessages(store);
  }

  void _addMessageToLocal(Store<AppState> store, Message message) {
    _chatHistoryAggregator.addMessage(message);
    _dispatchAllMessages(store);
  }

  void _dispatchAllMessages(Store<AppState> store) {
    store.dispatch(ChatSuccessAction(_chatHistoryAggregator.messages));
  }
}

class ChatNotInitializedError implements Exception {}
