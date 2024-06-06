import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_event_action.dart';
import 'package:pass_emploi_app/models/chat/offre_partagee.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:redux/redux.dart';

class ChatPartageMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _chatRepository;

  ChatPartageMiddleware(
    this._chatRepository,
  );

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (loginState is LoginSuccessState) {
      if (loginState.user.loginMode.isDemo()) return;
      final userId = loginState.user.id;
      if (action is ChatPartagerOffreAction) {
        _partagerOffre(store, userId, action.offre);
      } else if (action is ChatPartagerEventAction) {
        _partagerEvent(store, userId, action.eventPartage);
      } else if (action is ChatPartagerEvenementEmploiAction) {
        _partagerEvenementEmploi(store, userId, action.evenementEmploi);
      } else if (action is ChatPartagerSessionMiloAction) {
        _partageSessionMilo(store, userId, action.sessionMilo);
      }
    }
  }

  void _partagerOffre(Store<AppState> store, String userId, OffrePartagee offre) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _chatRepository.sendOffrePartagee(userId, offre);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.MESSAGE_OFFRE_PARTAGEE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partagerEvenementEmploi(Store<AppState> store, String userId, EvenementEmploiPartage evenementEmploi) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _chatRepository.sendEvenementEmploiPartage(userId, evenementEmploi);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.EVENEMENT_EXTERNE_PARTAGE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partagerEvent(Store<AppState> store, String userId, EventPartage eventPartage) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _chatRepository.sendEventPartage(userId, eventPartage);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.ANIMATION_COLLECTIVE_PARTAGEE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  void _partageSessionMilo(Store<AppState> store, String userId, SessionMiloPartage sessionMilo) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await _chatRepository.sendSessionMiloPartage(userId, sessionMilo);
    if (succeed) {
      store.dispatch(TrackingEventAction(EventType.MESSAGE_SESSION_MILO_PARTAGE));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }
}
