import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/repositories/user_action_pe_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/test_assets.dart';
import '../utils/test_datetime.dart';

void main() {
  test('get user actions pôle emploi when response is valid should return user actions list', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/pole-emploi/actions")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("user_action_pe.json"), 200);
    });
    final repository = UserActionPERepository("BASE_URL", httpClient);

    // When
    final List<UserActionPE>? result = await repository.getUserActions("UID");

    // Then
    expect(result, isNotNull);
    expect(result?.length, 5);
    expect(
      result?.first,
      UserActionPE(
        id: "8802034",
        content: "Faire le CV",
        status: UserActionPEStatus.NOT_STARTED,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
        deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
        createdByAdvisor: true,
      ),
    );
    expect(
      result?[1],
      UserActionPE(
        id: "8392839",
        content: "Compléter son CV",
        status: UserActionPEStatus.IN_PROGRESS,
        endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
        deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
        createdByAdvisor: true,
      ),
    );
  });

  test('get user actions pôle emploi when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = UserActionPERepository("BASE_URL", httpClient);

    // When
    final search = await repository.getUserActions("UserID");

    // Then
    expect(search, isNull);
  });
}
