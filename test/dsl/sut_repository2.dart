import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../doubles/dio_mock.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';

class RepositorySut2<REPO> {
  late Response<dynamic> Function() _response;
  late DioMock _client;
  late REPO _repository;
  late Future<dynamic> Function(REPO) _when;

  // Given

  void givenJsonResponse({required String fromJson, Map<String, String> headers = const {}}) {
    final data = jsonDecode(loadTestAssets(fromJson));
    givenResponse(() => Response(requestOptions: _makeRequestOptions(), data: data, statusCode: 200));
  }

  void givenResponseCode(int code) {
    givenResponse(() => Response(requestOptions: _makeRequestOptions(), statusCode: code));
  }

  void givenThrowingExceptionResponse() {
    givenResponse(() => throw Exception());
  }

  void givenResponse(Response<dynamic> Function() response) {
    setUp(() {
      _response = response;
    });
  }

  RequestOptions _makeRequestOptions() {
    return RequestOptions(path: "sut-path");
  }

  DioMock _makeClient() {
    return DioMock();
  }

  void givenRepository(REPO Function(DioMock) createRepository) {
    _client = _makeClient();
    setUp(() => _repository = createRepository(_client));
  }

  // When

  void wwhen(Future<dynamic> Function(REPO) wwwwhen) {
    setUp(
      () => _when = (repo) {
        when(() => _client.get(any())).thenAnswer((_) async => _response());
        return wwwwhen(repo);
      },
    );
  }

  // Then

  Future<void> expectRequestBody({
    required String method,
    required String url,
    Map<String, dynamic>? bodyFields,
    Map<String, dynamic>? jsonBody,
  }) async {
    await _when(_repository);

    final capturedUrl = verify(() => _client.get(captureAny())).captured.last; //TODO: only on get call
    // expect(captured[0], method);
    expect(capturedUrl, url);

    //TODO:
    // if (bodyFields != null) expect(_request.bodyFields, bodyFields);
    // if (jsonBody != null) expect(jsonUtf8Decode(_request.bodyBytes), jsonBody);
  }

  Future<void> expectResult<RESULT>(Function(RESULT) expectLambda) async {
    final result = await _when(_repository) as RESULT;
    expectLambda(result);
  }

  Future<void> expectNullResult() async {
    final result = await _when(_repository);
    expect(result, isNull);
  }

  Future<void> expectEmptyListAsResult() async {
    expectResult<List<dynamic>>((list) {
      expect(list, isEmpty);
    });
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
