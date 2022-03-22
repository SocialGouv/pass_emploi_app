import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/metier_repository.dart';
import 'package:redux/redux.dart';

class SearchMetierMiddleware extends MiddlewareClass<AppState> {
  final MetierRepository _repository;

  SearchMetierMiddleware(this._repository);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    if (action is SearchMetierRequestAction) {
      final input = action.input;
      final List<Metier> metiers = input != null ? await _repository.getMetiers(input) : [];
      store.dispatch(SearchMetierSuccessAction(metiers));
    }
  }
}
