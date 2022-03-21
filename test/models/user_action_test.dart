import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';

import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  test('UserAction.fromJson when complete data should deserialize data correctly with date on local timezone', () {
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
    expect(notStartedAction.lastUpdate, parseDateTimeWithCurrentTimeZone("Fri, 30 Jul 2021 09:43:09 GMT"));
    expect(notStartedAction.creator, JeuneActionCreator());

    expect(inProgressAction.content, "Compléter son CV");
    expect(inProgressAction.comment, "");
    expect(inProgressAction.id, "8392839");
    expect(inProgressAction.status, UserActionStatus.IN_PROGRESS);
    expect(inProgressAction.lastUpdate, parseDateTimeWithCurrentTimeZone("Fri, 24 Jul 2021 19:11:10 GMT"));
    expect(inProgressAction.creator, ConseillerActionCreator(name: "Nils Tavernier"));

    expect(doneAction.content, "M'inscrire au permis de conduire");
    expect(doneAction.comment, "Pour conduire");
    expect(doneAction.id, "5656467");
    expect(doneAction.status, UserActionStatus.DONE);
    expect(doneAction.lastUpdate, parseDateTimeWithCurrentTimeZone("Fri, 30 Jul 2021 09:42:50 GMT"));
    expect(doneAction.creator, ConseillerActionCreator(name: "Autre Conseiller"));
  });
}
