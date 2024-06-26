import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/models/chat/offre_partagee.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_bridge.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class ChatPartageMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _chatRepository;
  final CvmBridge _cvmBridge;
  final Crashlytics? _crashlytics;

  ChatPartageMiddleware(this._chatRepository, this._cvmBridge, this._crashlytics);

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
    _partager(
      store: store,
      onPartage: () {
        return store.useCvm()
            ? _sendCvmMessage("${offre.message}\n\n${offre.titre}\n↗ ${offre.url}")
            : _chatRepository.sendOffrePartagee(userId, offre);
      },
      eventType: EvenementEngagement.MESSAGE_OFFRE_PARTAGEE,
    );
  }

  void _partagerEvenementEmploi(Store<AppState> store, String userId, EvenementEmploiPartage evenementEmploi) async {
    _partager(
      store: store,
      onPartage: () {
        return store.useCvm()
            ? _sendCvmMessage("${evenementEmploi.message}\n\n${evenementEmploi.titre}\n↗ ${evenementEmploi.url}")
            : _chatRepository.sendEvenementEmploiPartage(userId, evenementEmploi);
      },
      eventType: EvenementEngagement.EVENEMENT_EXTERNE_PARTAGE,
    );
  }

  void _partagerEvent(Store<AppState> store, String userId, EventPartage eventPartage) async {
    _partager(
      store: store,
      onPartage: () {
        return store.useCvm()
            ? _sendCvmMessage("${eventPartage.message}\n\n${eventPartage.titre} le ${eventPartage.date.toDayAndHour()}")
            : _chatRepository.sendEventPartage(userId, eventPartage);
      },
      eventType: EvenementEngagement.ANIMATION_COLLECTIVE_PARTAGEE,
    );
  }

  void _partageSessionMilo(Store<AppState> store, String userId, SessionMiloPartage sessionMilo) async {
    _partager(
      store: store,
      onPartage: () => _chatRepository.sendSessionMiloPartage(userId, sessionMilo),
      eventType: EvenementEngagement.MESSAGE_SESSION_MILO_PARTAGE,
    );
  }

  void _partager({
    required Store<AppState> store,
    required Future<bool> Function() onPartage,
    required EvenementEngagement eventType,
  }) async {
    store.dispatch(ChatPartageLoadingAction());
    final succeed = await onPartage();
    if (succeed) {
      store.dispatch(TrackingEvenementEngagementAction(eventType));
      store.dispatch(ChatPartageSuccessAction());
    } else {
      store.dispatch(ChatPartageFailureAction());
    }
  }

  Future<bool> _sendCvmMessage(String message) async {
    try {
      return await _cvmBridge.sendMessage(message);
    } catch (e, s) {
      _crashlytics?.log("CvmBridge.sendMessage error");
      _crashlytics?.recordCvmException(e, s);
      return false;
    }
  }
}

extension on Store<AppState> {
  bool useCvm() => state.cvmState is! CvmNotInitializedState;
}
