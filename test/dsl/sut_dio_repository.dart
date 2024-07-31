import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
import 'package:pass_emploi_app/features/mode_demo/mode_demo_exception.dart';
import 'package:pass_emploi_app/network/status_code.dart';

import '../doubles/dio_mock.dart';
import '../utils/test_assets.dart';

class DioRepositorySut<REPO> {
  late Response<dynamic> Function() _response;
  late DioMock _client;
  late REPO _repository;
  late Future<dynamic> Function(REPO) _when;

  // Given

  void givenJsonResponse({required String fromJson}) {
    final data = jsonDecode(loadTestAssets(fromJson));
    givenResponse(() => Response(requestOptions: _makeRequestOptions(), data: data, statusCode: 200));
  }

  void givenRawResponse({required String data}) {
    givenResponse(() => Response(requestOptions: _makeRequestOptions(), data: data, statusCode: 200));
  }

  void givenResponseCode(int code) {
    dynamic data() {
      final error = DioException(
        requestOptions: _makeRequestOptions(),
        response: Response(requestOptions: _makeRequestOptions(), statusCode: code),
        message: "RepositorySut: givenResponseCode $code",
      );
      return code.isValid() ? null : throw error;
    }

    givenResponse(() => Response(requestOptions: _makeRequestOptions(), statusCode: code, data: data()));
  }

  void givenBytesResponse(List<int> bytes) {
    givenResponse(() => Response(requestOptions: _makeRequestOptions(), data: bytes, statusCode: 200));
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
        mocktail.reset(_client);
        mocktail //
            .when(() => _client.get(
                  mocktail.any(),
                  queryParameters: mocktail.any(named: "queryParameters"),
                  options: mocktail.any(named: "options"),
                ))
            .thenAnswer((_) async => _response());
        mocktail //
            .when(() => _client.post(
                  mocktail.any(),
                  data: mocktail.any(named: "data"),
                  options: mocktail.any(named: "options"),
                ))
            .thenAnswer((_) async => _response());
        mocktail //
            .when(() => _client.patch(
                  mocktail.any(),
                  data: mocktail.any(named: "data"),
                  options: mocktail.any(named: "options"),
                ))
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
    dynamic jsonBody,
    Object? rawBody,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _when(_repository);

    final dynamic capturedUrl;
    dynamic capturedData;
    dynamic capturedQueryParameters;
    dynamic capturedOptions;
    switch (method) {
      case HttpMethod.get:
        final captured = mocktail
            .verify(() => _client.get(
                  mocktail.captureAny(),
                  queryParameters: mocktail.captureAny(named: "queryParameters"),
                  options: mocktail.captureAny(named: "options"),
                ))
            .captured;
        capturedUrl = captured[0];
        capturedQueryParameters = captured[1];
        capturedOptions = captured[2];
        break;
      case HttpMethod.post:
        final captured = mocktail
            .verify(() => _client.post(
                  mocktail.captureAny(),
                  data: mocktail.captureAny(named: "data"),
                  options: mocktail.captureAny(named: "options"),
                ))
            .captured;
        capturedUrl = captured[0];
        capturedData = captured[1];
        capturedOptions = captured[2];
        break;
      case HttpMethod.put:
        final captured = mocktail
            .verify(() => _client.put(
                  mocktail.captureAny(),
                  data: mocktail.captureAny(named: "data"),
                  options: mocktail.captureAny(named: "options"),
                ))
            .captured;
        capturedUrl = captured[0];
        capturedData = captured[1];
        capturedOptions = captured[2];
        break;
      case HttpMethod.patch:
        final captured = mocktail
            .verify(() => _client.patch(
                  mocktail.captureAny(),
                  data: mocktail.captureAny(named: "data"),
                  options: mocktail.captureAny(named: "options"),
                ))
            .captured;
        capturedUrl = captured[0];
        capturedData = captured[1];
        capturedOptions = captured[2];
        break;
      case HttpMethod.delete:
        capturedUrl = mocktail.verify(() => _client.delete(mocktail.captureAny())).captured.last;
        break;
    }

    expect(capturedUrl, url);
    if (jsonBody != null) expect(jsonDecode(capturedData as String), jsonBody);
    if (rawBody != null) expect(capturedData, rawBody);
    if (capturedQueryParameters != null) expect(capturedQueryParameters, queryParameters);
    if (capturedOptions != null) {
      if (options?.contentType != null) expect(capturedOptions.contentType, options?.contentType);
      if (options?.listFormat != null) expect(capturedOptions.listFormat, options?.listFormat);
    }
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

enum HttpMethod { get, post, put, delete, patch }
