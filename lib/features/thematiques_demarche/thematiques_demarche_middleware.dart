import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/features/generic/generic_middleware.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';

class ThematiqueDemarcheMiddleware extends GenericMiddleware<NoRequest, List<ThematiqueDeDemarche>> {
  final ThematiqueDemarcheRepository _repository;

  ThematiqueDemarcheMiddleware(this._repository);

  @override
  Future<List<ThematiqueDeDemarche>?> getData(String userId, NoRequest request) => _repository.getThematique();
}
