import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/auth/chat_security_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<ChatSecurityRepository>();
  sut.givenRepository((client) => ChatSecurityRepository(client));

  group('getFirebaseAuth', () {
    sut.when((repository) => repository.getChatSecurityInfos('userId'));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "firebase_auth_token.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.post,
          url: '/auth/firebase/token',
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<ChatSecurityResponse?>((result) {
          expect(result, ChatSecurityResponse(firebaseAuthToken: "FIREBASE-TOKEN", chatEncryptionKey: "CLE"));
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
