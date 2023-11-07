import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/features/generic/generic_middleware.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';

class DetailsJeuneMiddleware extends GenericMiddleware<NoRequest, DetailsJeune> {
  final DetailsJeuneRepository _repository;

  DetailsJeuneMiddleware(this._repository);

  @override
  Future<DetailsJeune?> getData(String userId, NoRequest request) => _repository.fetch(userId);
}
