import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_chat_repository.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_super_repository.dart';
import 'package:redux/redux.dart';

class ChatMiddleware2 extends MiddlewareClass<AppState> {
  final ChatSuperRepository _repository;

  ChatMiddleware2(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is LoginSuccessAction || action is RequestLogoutAction || action is NotLoggedInAction) {
      _repository.resetMessageStream();
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
          _repository.pauseMessagesStream();
        } else if (action is SendMessageAction) {
          _sendMessage(store, userId, action.message);
        } else if (action is ChatRequestMorePastAction) {
          _loadOldMessages(userId, store);
        } else if (action is ChatPartagerOffreAction) {
          _partagerOffre(store, userId, action.offre);
        } else if (action is ChatPartagerEventAction) {
          _partagerEvent(store, userId, action.eventPartage);
        } else if (action is ChatPartagerEvenementEmploiAction) {
          _partagerEvenementEmploi(store, userId, action.evenementEmploi);
        } else if (action is ChatPartagerSessionMiloAction) {
          _partageSessionMilo(store, userId, action.sessionMilo);
        } else if (action is LastMessageSeenAction) {
          _repository.setLastMessageSeen();
        } else if (action is ChatRequestMorePastAction) {
          _loadOldMessages(userId, store);
        }
      }
    }
  }

  void _sendMessage(Store<AppState> store, String userId, String messageText) async {
    _repository.sendMessage(messageText);
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
    _repository.startMessagesStream().listen(
      (messages) {
        store.dispatch(ChatSuccessAction(messages));
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
    _repository.loadOldMessages();
  }

  void _partagerOffre(Store<AppState> store, String userId, OffrePartagee offre) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _repository.sendOffrePartagee(offre);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.MESSAGE_OFFRE_PARTAGEE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partagerEvenementEmploi(Store<AppState> store, String userId, EvenementEmploiPartage evenementEmploi) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _repository.sendEvenementEmploiPartage(evenementEmploi);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.MESSAGE_EVENEMENT_EMPLOI_PARTAGE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partagerEvent(Store<AppState> store, String userId, EventPartage eventPartage) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _repository.sendEventPartage(eventPartage);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.ANIMATION_COLLECTIVE_PARTAGEE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partageSessionMilo(Store<AppState> store, String userId, SessionMiloPartage sessionMilo) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _repository.sendSessionMiloPartage(sessionMilo);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.MESSAGE_SESSION_MILO_PARTAGE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }
}

class ChatNotInitializedError implements Exception {}
