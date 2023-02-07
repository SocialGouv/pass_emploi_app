import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';

class RechercheRequestAction<Criteres extends Equatable, Filtres extends Equatable> {
  final RechercheRequest<Criteres, Filtres> request;

  RechercheRequestAction(this.request);
}

class RechercheSuccessAction<Criteres extends Equatable, Filtres extends Equatable, Result> {
  final RechercheRequest<Criteres, Filtres> request;
  final List<Result> results;
  final bool canLoadMore;

  RechercheSuccessAction(this.request, this.results, this.canLoadMore);
}

class RechercheFailureAction<Result> {}

class RechercheUpdateFiltresAction<Filtres> {
  final Filtres filtres;

  RechercheUpdateFiltresAction(this.filtres);
}

class RechercheLoadMoreAction<Result> {}

class RechercheNewAction<Result> {}

class RechercheResetAction<Result> {}
