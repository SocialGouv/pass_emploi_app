import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';

import '../doubles/mocks.dart';
import '../dsl/sut_dio_repository.dart';

void main() {
  final mockFirebase = MockFirebaseInstanceIdGetter();
  final mockNotification = MockPushNotificationManager();
  final sut = DioRepositorySut<ConfigurationApplicationRepository>();
  sut.givenRepository((client) => ConfigurationApplicationRepository(client, mockFirebase, mockNotification));

  setUp(() {
    reset(mockFirebase);
    reset(mockNotification);
    mockFirebase.mockGetFirebaseInstanceId();
    mockNotification.mockGetToken();
  });

  group("sendEvent", () {
    sut.when((repository) => repository.configureApplication("userId", "fuseauHoraire"));

    group('when response is valid', () {
      sut.givenResponseCode(201);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.put,
          url: "/jeunes/userId/configuration-application",
          options: Options(headers: {'X-InstanceId': "firebaseId"}),
          jsonBody: {
            'registration_token': 'token',
            'fuseauHoraire': 'fuseauHoraire',
          },
        );
      });
    });
  });
}
