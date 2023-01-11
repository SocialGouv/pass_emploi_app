import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mocktail;
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
    //TODO: actuellement la lib Dio fait péter une exception quand c'est un mauvais status code.
    // Si on mock une réponse avec un code 500, ça ne fait pas péter l'exception
    // Deux solutions :
    // - on throw une exception quand c'est un code invalide
    // - on garde le if code.isValid dans les repo (avantage: on reste indépendant de la lib. inconvénient: faut l'écrire)
    dynamic data() => code.isValid() ? null : throw Exception("SUT: invalid HTTP code.");
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
    //TODO: attention, si on ne met pas un "any" sur un paramètre qu'on utilise dans get/post/etc, ça ne marche pas #relou #viveLeVanillaMocking
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
    Map<String, dynamic>? bodyFields,
    Map<String, dynamic>? jsonBody,
  }) async {
    await _when(_repository);

    final dynamic capturedUrl;
    dynamic capturedData;
    //TODO: attention, si on ne met pas un "any" sur un paramètre qu'on utilise dans get/post/etc, ça ne marche pas #relou #viveLeVanillaMocking
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

    //TODO: bodyFields, si un repo l'utilise sinon suppr
    //if (bodyFields != null) expect(_request.bodyFields, bodyFields);
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

//TODO: move?
enum HttpMethod { get, post, put, delete }
