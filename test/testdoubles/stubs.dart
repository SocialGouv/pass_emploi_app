import 'package:pass_emploi_app/models/user_action.dart';
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
        isDone: false,
        lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
      ),
    ];
  }

  @override
  Future<void> updateActionStatus(String userId, String actionId, bool newIsDoneValue) async {}
}
