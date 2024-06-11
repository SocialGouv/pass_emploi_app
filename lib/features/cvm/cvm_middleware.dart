import 'dart:async';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_actions.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/features/feature_flip/feature_flip_actions.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/models/conseiller_messages_info.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_alerting_repository.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_bridge.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_facade.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_last_reading_repository.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_token_repository.dart';
import 'package:redux/redux.dart';

class CvmMiddleware extends MiddlewareClass<AppState> {
  final CvmFacade _facade;
  final CvmLastReadingRepository _lastReadingRepository;
  final CvmAlertingRepository _alertingRepository;
  StreamSubscription<List<CvmMessage>>? _subscription;

  CvmMiddleware(
    CvmBridge bridge,
    CvmTokenRepository tokenRepository,
    this._lastReadingRepository,
    this._alertingRepository,
    Crashlytics crashlytics,
  ) : _facade = CvmFacade(bridge, tokenRepository, crashlytics);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    _handleLogoutBeforeNext(store, action);
    next(action);

    if (_shouldStartCvm(action)) {
      _start(store);
    } else if (action is CvmSendMessageAction) {
      _facade.sendMessage(action.message);
    } else if (action is CvmLoadMoreAction) {
      _facade.loadMore();
    } else if (action is CvmLastJeuneReadingAction) {
      _handleLastJeuneReading(store);
    } else if (action is CvmSuccessAction) {
      _handleChatStatus(store, action.messages);
    }
  }

  Future<void> _handleLogoutBeforeNext(Store<AppState> store, dynamic action) async {
    if (action is! RequestLogoutAction) return;
    if (store.state.cvmState is CvmNotInitializedState) return;
    _subscription?.cancel();
    _facade.stop();
    await _facade.logout();
  }

  bool _shouldStartCvm(dynamic action) {
    return action is CvmRequestAction || (action is FeatureFlipUseCvmAction && action.useCvm);
  }

  void _start(Store<AppState> store) async {
    if (store.state.cvmState is CvmSuccessState) return;
    final userId = store.state.userId();
    if (userId == null) return;

    store.dispatch(CvmLoadingAction());

    _subscription?.cancel();
    _facade.stop();
    _subscription = _facade.start(userId).listen(
      (messages) => store.dispatch(CvmSuccessAction(messages)),
      onError: (_) {
        store.dispatch(CvmFailureAction());
        _alertingRepository.traceFailure();
      },
    );
  }

  void _handleLastJeuneReading(Store<AppState> store) {
    if (store.state.cvmState is! CvmSuccessState) return;
    final lastConseillerMessage = (store.state.cvmState as CvmSuccessState)
        .messages //
        .where((e) =>
            (e is CvmTextMessage && e.sentBy == Sender.conseiller) ||
            (e is CvmFileMessage && e.sentBy == Sender.conseiller))
        .sorted((a, b) => a.date.compareTo(b.date))
        .lastOrNull;
    if (lastConseillerMessage != null) {
      _facade.markAsRead(lastConseillerMessage.id);
    }

    // TODO Delete _lastReadingRepository when markAsRead is fully functional
    _lastReadingRepository.saveLastJeuneReading(clock.now());
    final statusState = store.state.chatStatusState;
    final lastConseillerReading = (statusState is ChatStatusSuccessState) ? statusState.lastConseillerReading : null;
    store.dispatch(
      ChatConseillerMessageAction(ConseillerMessageInfo(false, lastConseillerReading)),
    );
  }

  Future<void> _handleChatStatus(Store<AppState> store, List<CvmMessage> messages) async {
    final lastConseillerReading = messages //
        .whereType<CvmTextMessage>()
        .where((e) => e.readByConseiller)
        .map((e) => e.date)
        .maxOrNull;

    final lastConseillerMessage = messages.where((message) => message.isFromConseiller()).lastOrNull;
    final lastJeuneReading = await _lastReadingRepository.getLastJeuneReading();
    final hasUnreadMessages = lastJeuneReading == null || lastConseillerMessage?.date.isAfter(lastJeuneReading) == true;

    if (hasUnreadMessages || lastConseillerReading != null) {
      store.dispatch(ChatConseillerMessageAction(ConseillerMessageInfo(hasUnreadMessages, lastConseillerReading)));
    }
  }
}
