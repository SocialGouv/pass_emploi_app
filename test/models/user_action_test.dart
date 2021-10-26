import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';

import '../utils/test_assets.dart';

main() {
  test('UserAction.fromJson when complete data should deserialize data correctly', () {
    // Given
    final String userActionString = loadTestAssets("user_action.json");
    final userActionJson = json.decode(userActionString);

    // When
    final notStartedAction = UserAction.fromJson(userActionJson[0]);
    final inProgressAction = UserAction.fromJson(userActionJson[1]);
    final doneAction = UserAction.fromJson(userActionJson[2]);

    // Then
    expect(notStartedAction.content, "Changer de prénom");
    expect(notStartedAction.comment, "Commentaire");
    expect(notStartedAction.id, "8802034");
    expect(notStartedAction.status, UserActionStatus.NOT_STARTED);
    expect(notStartedAction.lastUpdate, DateTime(2021, 7, 30, 9, 43, 9));
    expect(notStartedAction.creator, JeuneActionCreator());

    expect(inProgressAction.content, "Compléter son CV");
    expect(inProgressAction.comment, "");
    expect(inProgressAction.id, "8392839");
    expect(inProgressAction.status, UserActionStatus.IN_PROGRESS);
    expect(inProgressAction.lastUpdate, DateTime(2021, 7, 24, 19, 11, 10));
    expect(inProgressAction.creator, ConseillerActionCreator(name: "Nils Tavernier"));

    expect(doneAction.content, "M'inscrire au permis de conduire");
    expect(doneAction.comment, "Pour conduire");
    expect(doneAction.id, "5656467");
    expect(doneAction.status, UserActionStatus.DONE);
    expect(doneAction.lastUpdate, DateTime(2021, 7, 30, 9, 42, 50));
    expect(doneAction.creator, ConseillerActionCreator(name: "Autre Conseiller"));
  });
}
