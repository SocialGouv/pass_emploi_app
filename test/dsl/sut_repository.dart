import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';

import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';

class RepositorySut<REPO> {
  late Response Function() _response;
  late Request _request;
  late REPO _repository;
  late Future<dynamic> Function(REPO) _when;

  void givenJsonResponse({required String fromJson, Map<String, String> headers = const {}}) {
    givenResponse(() => Response.bytes(loadTestAssetsAsBytes(fromJson), headers: headers, 200));
  }

  void givenResponseCode(int code) {
    givenResponse(() => Response('', code));
  }

  void givenThrowingExceptionResponse() {
    givenResponse(() => throw Exception());
  }

  void givenResponse(Response Function() response) {
    setUp(() {
      _response = response;
    });
  }

  Client _makeClient() {
    return PassEmploiMockClient((request) async {
      _request = request;
      return _response();
    });
  }

  void givenRepository(REPO Function(Client) createRepository) {
    setUp(() => _repository = createRepository(_makeClient()));
  }

  void when(Future<dynamic> Function(REPO) when) {
    setUp(() => _when = when);
  }

  Future<void> expectRequestBody({required String method, required String url, Map<String, dynamic>? params}) async {
    await _when(_repository);

    expect(_request.method, method);
    expect(_request.url.toString(), url);

    if (params != null) expect(jsonUtf8Decode(_request.bodyBytes), params);
  }

  Future<void> expectResult<RESULT>(Function(RESULT) expectLambda) async {
    final result = await _when(_repository) as RESULT;
    expectLambda(result);
  }

  Future<void> expectNullResult() async {
    final result = await _when(_repository);
    expect(result, isNull);
  }

  Future<void> expectTrueAsResult() async {
    final result = await _when(_repository);
    expect(result, true);
  }

  Future<void> expectFalseAsResult() async {
    final result = await _when(_repository);
    expect(result, false);
  }
}
