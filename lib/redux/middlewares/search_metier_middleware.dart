import 'package:pass_emploi_app/redux/actions/search_metier_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../../models/metier.dart';
import '../../repositories/metier_repository.dart';

class SearchMetierMiddleware extends MiddlewareClass<AppState> {
  final MetierRepository _repository;

  SearchMetierMiddleware(this._repository);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is RequestMetierAction) {
      final input = action.input;
      final List<Metier> metiers = input != null ? await _repository.getMetiers(input) : [];
      store.dispatch(SearchMetierSuccessAction(metiers));
    }
  }
}
