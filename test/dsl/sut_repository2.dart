import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:pass_emploi_app/features/mode_demo/mode_demo_exception.dart';
import 'package:pass_emploi_app/network/status_code.dart';

import '../doubles/dio_mock.dart';
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
    dynamic data() {
      return code.isValid() ? null : throw Exception("Mocking client: exception thrown when status code is invalid.");
    }

    givenResponse(() => Response(requestOptions: _makeRequestOptions(), statusCode: code, data: data()));
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

  void when(Future<dynamic> Function(REPO) when) {
    setUp(() {
      _when = (repo) {
        mocktail //
            .when(() => _client.get(mocktail.any()))
            .thenAnswer((_) async => _response());
        mocktail //
            .when(() => _client.post(mocktail.any(), data: mocktail.any(named: "data")))
            .thenAnswer((_) async => _response());
        mocktail //
            .when(() => _client.put(mocktail.any(), data: mocktail.any(named: "data")))
            .thenAnswer((_) async => _response());
        mocktail //
            .when(() => _client.delete(mocktail.any()))
            .thenAnswer((_) async => _response());
        return when(repo);
      };
    });
  }

  // Then on request

  Future<void> expectRequestBody({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? jsonBody,
  }) async {
    await _when(_repository);

    final dynamic capturedUrl;
    dynamic capturedData;
    switch (method) {
      case HttpMethod.get:
        capturedUrl = mocktail.verify(() => _client.get(mocktail.captureAny())).captured.last;
        break;
      case HttpMethod.post:
        final captured = mocktail
            .verify(() => _client.post(mocktail.captureAny(), data: mocktail.captureAny(named: "data")))
            .captured;
        capturedUrl = captured[0];
        capturedData = captured[1];
        break;
      case HttpMethod.put:
        final captured = mocktail
            .verify(() => _client.put(mocktail.captureAny(), data: mocktail.captureAny(named: "data")))
            .captured;
        capturedUrl = captured[0];
        capturedData = captured[1];
        break;
      case HttpMethod.delete:
        capturedUrl = mocktail.verify(() => _client.delete(mocktail.captureAny())).captured.last;
        break;
    }

    expect(capturedUrl, url);
    if (jsonBody != null) expect(jsonDecode(capturedData as String), jsonBody);
    throwModeDemoExceptionIfNecessary(method == HttpMethod.get, Uri.parse(url));
  }

  // Then on result

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

enum HttpMethod { get, post, put, delete }
