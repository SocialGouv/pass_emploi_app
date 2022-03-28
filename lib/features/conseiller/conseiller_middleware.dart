import 'package:pass_emploi_app/features/conseiller/conseiller_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/conseiller_repository.dart';
import 'package:redux/redux.dart';

class ConseillerMiddleware extends MiddlewareClass<AppState> {
  final ConseillerRepository _repository;

  ConseillerMiddleware(this._repository);

  @override
  call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    next(action);
    if (action is ConseillerRequestAction) await _handleRequestAction(store);
  }

  Future<void> _handleRequestAction(Store<AppState> store) async {
    store.dispatch(ConseillerLoadingAction());
    final result = await _repository.fetch();
    store.dispatch(ConseillerSuccessAction(conseillerInfo: result));
  }
}