import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/details_session_milo.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/repositories/session_milo_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_dio_repository.dart';

void main() {
  group('SessionMiloRepository', () {
    final sut = DioRepositorySut<SessionMiloRepository>();
    sut.givenRepository((client) => SessionMiloRepository(client));

    group('getList', () {
      test("description", () => expect(mockSessionMilo(), isNotNull));
      test("description", () => expect(SessionMilo(), isNotNull));
    });
    group('getDetails', () {
      test("description", () => expect(DetailsSessionMilo(), isNotNull));
    });
  });
}
