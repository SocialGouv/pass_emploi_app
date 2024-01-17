import 'dart:async';

import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/cvm_repository.dart';
import 'package:redux/redux.dart';

class CvmMiddleware extends MiddlewareClass<AppState> {
  final CvmRepository _repository;

  CvmMiddleware(this._repository);

  final List<CvmMessage> messages = [];

  void _subscribeToChatStream(Store<AppState> store) {
    _repository.getMessages().listen(
      (messages) {
        store.dispatch(CvmSuccessAction(messages));
      },
      onError: (Object error) {
        store.dispatch(CvmFailureAction());
      },
    );
  }

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is CvmAction) {
      handleAction(store, action);
    }
  }

  void handleAction(Store<AppState> store, CvmAction action) {
    if (action is CvmRequestAction) {
      _initCvm(store, _repository);
    } else if (action is CvmSendMessageAction) {
      _repository.sendMessage(action.message);
    }
  }

  Future<void> _initCvm(Store<AppState> store, CvmRepository repository) async {
    store.dispatch(CvmLoadingAction());
    try {
      await repository.init();
      _subscribeToChatStream(store);
    } catch (e) {
      store.dispatch(CvmFailureAction());
    }
  }
}
