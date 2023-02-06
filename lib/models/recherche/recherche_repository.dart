import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';

abstract class RechercheRepository<Criteres extends Equatable, Filtres extends Equatable, Result> {
  Future<RechercheResponse<Result>?> rechercher({
    required String userId,
    required RechercheRequest<Criteres, Filtres> request,
  });
}

class RechercheResponse<Result> {
  final List<Result> results;
  final bool canLoadMore;

  RechercheResponse({
    required this.results,
    required this.canLoadMore,
  });
}
