import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/auth/logout_repository.dart';

import '../../doubles/dummies.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<LogoutRepository>();
  sut.givenRepository((client) {
    final repository = LogoutRepository(
      authIssuer: 'AUTH_ISSUER',
      clientSecret: 'CLIENT_SECRET',
      clientId: 'CLIENT_ID',
    );
    repository.setHttpClient(client);
    repository.setCacheManager(DummyPassEmploiCacheManager());
    return repository;
  });

  group('logout', () {
    sut.when((repository) => repository.logout('REFRESH_TOKEN'));

    group('when response is valid', () {
      sut.givenResponseCode(HttpStatus.noContent);
      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.post,
          url: 'AUTH_ISSUER/protocol/openid-connect/logout',
          rawBody: 'client_id=CLIENT_ID&refresh_token=REFRESH_TOKEN&client_secret=CLIENT_SECRET',
          options: Options(contentType: 'application/x-www-form-urlencoded'),
        );
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(HttpStatus.badRequest);

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
