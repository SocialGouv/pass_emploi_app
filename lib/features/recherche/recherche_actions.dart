import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';

class RechercheRequestAction<Criteres extends Equatable, Filtres extends Equatable> {
  final RechercheRequest<Criteres, Filtres> request;

  RechercheRequestAction(this.request);
}

class RechercheSuccessAction<Result> {
  final List<Result> results;
  final bool canLoadMore;

  RechercheSuccessAction(this.results, this.canLoadMore);
}

//TODO: il faudra type générique sinon tous les reducers vont capturer
class RechercheFailureAction {}

class RechercheUpdateFiltres<Filtres> {
  final Filtres filtres;

  RechercheUpdateFiltres(this.filtres);
}

class RechercheLoadMoreAction<Result> {}

//TODO: il faudra type générique sinon tous les reducers vont capturer
class RechercheNewAction {}

//TODO: il faudra type générique sinon tous les reducers vont capturer
class RechercheResetAction {}
