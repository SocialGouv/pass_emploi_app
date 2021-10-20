import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';

import '../utils/test_assets.dart';

main() {
  test('UserAction.fromJson when complete data should deserialize data correctly', () {
    // Given
    final String userActionString = loadTestAssets("user_action.json");
    final userActionJson = json.decode(userActionString);

    // When
    final doneAction = UserAction.fromJson(userActionJson[0]);
    final notStartedAction = UserAction.fromJson(userActionJson[1]);

    // Then
    expect(doneAction.id, "8802034");
    expect(doneAction.content, "Changer de prénom");
    expect(doneAction.comment, "Commentaire");
    expect(doneAction.status, UserActionStatus.DONE);
    expect(doneAction.lastUpdate, DateTime(2021, 7, 30, 9, 43, 9));

    expect(notStartedAction.status, UserActionStatus.NOT_STARTED);
  });
}
