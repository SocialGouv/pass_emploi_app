import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';

import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  test('UserActionPE.fromJson when complete data should deserialize data correctly with date on local timezone', () {
    // Given
    final String userActionString = loadTestAssets("user_action_pe.json");
    final userActionJson = json.decode(userActionString);

    // When
    final notStartedAction = UserActionPE.fromJson(userActionJson[0]);
    final inProgressAction = UserActionPE.fromJson(userActionJson[1]);
    final retardedAction = UserActionPE.fromJson(userActionJson[2]);
    final doneAction = UserActionPE.fromJson(userActionJson[3]);
    final cancelledAction = UserActionPE.fromJson(userActionJson[4]);

    // Then
    expect(notStartedAction.id, "8802034");
    expect(notStartedAction.content, "Faire le CV");
    expect(notStartedAction.status, UserActionPEStatus.NOT_STARTED);
    expect(notStartedAction.endDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(notStartedAction.deletionDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(notStartedAction.createdByAdvisor, true);

    expect(inProgressAction.id, "8392839");
    expect(inProgressAction.content, "Compléter son CV");
    expect(inProgressAction.status, UserActionPEStatus.IN_PROGRESS);
    expect(inProgressAction.endDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(notStartedAction.deletionDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(inProgressAction.createdByAdvisor, true);

    expect(retardedAction.id, "8392832");
    expect(retardedAction.content, "M'inscrire au permis de conduire");
    expect(retardedAction.status, UserActionPEStatus.RETARDED);
    expect(retardedAction.endDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(notStartedAction.deletionDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(retardedAction.createdByAdvisor, true);

    expect(doneAction.id, "8792832");
    expect(doneAction.content, "Faire un test IQ");
    expect(doneAction.status, UserActionPEStatus.DONE);
    expect(doneAction.endDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(notStartedAction.deletionDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(doneAction.createdByAdvisor, true);

    expect(cancelledAction.id, "8796832");
    expect(cancelledAction.content, "Supprimer son CV");
    expect(cancelledAction.status, UserActionPEStatus.CANCELLED);
    expect(cancelledAction.endDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(notStartedAction.deletionDate, parseDateTimeUtcWithCurrentTimeZone("2022-03-28T16:06:48.396Z"));
    expect(cancelledAction.createdByAdvisor, true);
  });
}
