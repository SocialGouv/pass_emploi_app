import 'dart:async';

import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_bridge.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_facade.dart';
import 'package:pass_emploi_app/repositories/cvm/cvm_token_repository.dart';
import 'package:redux/redux.dart';

class CvmMiddleware extends MiddlewareClass<AppState> {
  final CvmFacade _facade;
  StreamSubscription<List<CvmMessage>>? _subscription;

  CvmMiddleware(
    CvmBridge bridge,
    CvmTokenRepository tokenRepository, [
    Crashlytics? crashlytics,
  ]) : _facade = CvmFacade(bridge, tokenRepository, crashlytics);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is CvmRequestAction) {
      _start(store);
    } else if (_shouldLogout(store, action)) {
      _logout();
    } else if (action is CvmSendMessageAction) {
      _facade.sendMessage(action.message);
    } else if (action is CvmLoadMoreAction) {
      _facade.loadMore();
    }
  }

  void _start(Store<AppState> store) async {
    if (store.state.cvmState is CvmSuccessState) return;
    final userId = store.state.userId();
    if (userId == null) return;

    store.dispatch(CvmLoadingAction());

    _subscription?.cancel();
    _subscription = _facade.start(userId).listen(
          (messages) => store.dispatch(CvmSuccessAction(messages)),
          onError: (_) => store.dispatch(CvmFailureAction()),
        );
  }

  void _logout() {
    _subscription?.cancel();
    _facade.stop();
    _facade.logout();
  }

  bool _shouldLogout(Store<AppState> store, action) {
    return action is RequestLogoutAction && store.state.cvmState is! CvmNotInitializedState;
  }
}
