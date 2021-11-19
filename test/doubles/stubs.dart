import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';

import 'dummies.dart';

class UserActionRepositorySuccessStub extends UserActionRepository {
  UserActionRepositorySuccessStub() : super("", DummyHeadersBuilder());

  @override
  Future<List<UserAction>?> getUserActions(String userId) async {
    return [
      UserAction(
        id: "id",
        content: "content",
        comment: "comment",
        status: UserActionStatus.NOT_STARTED,
        lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
        creator: JeuneActionCreator(),
      ),
    ];
  }

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {}
}

class OffreEmploiRepositorySuccessStub extends OffreEmploiRepository {
  OffreEmploiRepositorySuccessStub() : super("", DummyHeadersBuilder());

  @override
  Future<List<OffreEmploi>?> search({
    required String userId,
    required String keywords,
    required String department,
    required int page,
  }) async {
    return offreEmploiData();
  }
}

class OffreEmploiRepositoryFailureStub extends OffreEmploiRepository {
  OffreEmploiRepositoryFailureStub() : super("", DummyHeadersBuilder());

  @override
  Future<List<OffreEmploi>?> search({
    required String userId,
    required String keywords,
    required String department,
    required int page,
  }) async {
    return null;
  }
}