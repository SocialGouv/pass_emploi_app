import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/repositories/auth/logout_repository.dart';

import '../../doubles/fixtures.dart';

void main() {
  test('logout should properly build request', () async {
    // Given
    bool requestIsProperlyBuilt = false;
    final httpClient = MockClient((request) async {
      if (request.method != "POST") return invalidHttpResponse();
      if (request.url.toString() != 'AUTH_ISSUER/protocol/openid-connect/logout') return invalidHttpResponse();
      if (request.encoding.toString() != Encoding.getByName('utf-8').toString()) return invalidHttpResponse();
      if (request.headers['Content-Type'] != 'application/x-www-form-urlencoded; charset=utf-8') {
        return invalidHttpResponse();
      }
      if (request.body.toString() != 'client_id=CLIENT_ID&refresh_token=REFRESH_TOKEN&client_secret=CLIENT_SECRET') {
        return invalidHttpResponse();
      }
      requestIsProperlyBuilt = true;
      return Response.bytes([], 204);
    });
    final repository = LogoutRepository('AUTH_ISSUER', 'CLIENT_SECRET', 'CLIENT_ID');
    repository.setHttpClient(httpClient);

    // When
    await repository.logout('REFRESH_TOKEN');

    // Then
    expect(requestIsProperlyBuilt, isTrue);
  });
}
