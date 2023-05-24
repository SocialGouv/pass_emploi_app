import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';

import '../../dsl/sut_repository2.dart';

void main() {
  final sut = RepositorySut2<FirebaseAuthRepository>();
  sut.givenRepository((client) => FirebaseAuthRepository(client));

  group('getFirebaseAuth', () {
    sut.when((repository) => repository.getFirebaseAuth('userId'));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "firebase_auth_token.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.post,
          url: '/auth/firebase/token',
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<FirebaseAuthResponse?>((result) {
          expect(result, FirebaseAuthResponse(token: "FIREBASE-TOKEN", key: "CLE"));
        });
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(400);

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });

    group('when response throws exception', () {
      sut.givenThrowingExceptionResponse();

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });
}
