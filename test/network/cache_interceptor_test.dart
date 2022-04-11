import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/network/cache_interceptor.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';

import '../doubles/dummies.dart';
import '../doubles/dummies_for_cache.dart';
import 'mock_file.dart';

void main() {
  test("when call is a POST, should not use cache", () async {
    // Given
    final networkClient = StubSuccessHttpClient();
    final cacheManager = DummyPassEmploiCacheManager();
    final clientWithCache = HttpClientWithCache(cacheManager, networkClient);

    // When
    clientWithCache.send(Request("POST", Uri.parse("https://yolo.com")));

    // Then
    expect(networkClient.hasBeenCalled, true);
  });

  test("when call is a DELETE, should not use cache", () async {
    // Given
    final networkClient = StubSuccessHttpClient();
    final cacheManager = DummyPassEmploiCacheManager();
    final clientWithCache = HttpClientWithCache(cacheManager, networkClient);

    // When
    clientWithCache.send(Request("DELETE", Uri.parse("https://yolo.com")));

    // Then
    expect(networkClient.hasBeenCalled, true);
  });

  test("when call is a PUT, should not use cache", () async {
    // Given
    final networkClient = StubSuccessHttpClient();
    final cacheManager = DummyPassEmploiCacheManager();
    final clientWithCache = HttpClientWithCache(cacheManager, networkClient);

    // When
    clientWithCache.send(Request("PUT", Uri.parse("https://yolo.com")));

    // Then
    expect(networkClient.hasBeenCalled, true);
  });

  test("when call is a GET, should use cache", () async {
    // Given
    final networkClient = StubSuccessHttpClient();
    final cacheManager = FullCacheMock();
    final clientWithCache = HttpClientWithCache(cacheManager, networkClient);

    // When
    clientWithCache.send(Request("GET", Uri.parse("https://yolo.com")));

    // Then
    expect(networkClient.hasBeenCalled, false);
  });

  test("when call is a GET in actions or rendez vous, should not use cache", () async {
    // Given
    final networkClient = StubSuccessHttpClient();
    final cacheManager = FullCacheMock();
    final clientWithCache = HttpClientWithCache(cacheManager, networkClient);

    // When
    clientWithCache.send(Request("GET", Uri.parse("https://yolo.com/rendezvous")));

    // Then
    expect(networkClient.callCount, 1);
    clientWithCache.send(Request("GET", Uri.parse("https://yolo.com/actions")));
    expect(networkClient.callCount, 2);
  });
}

class StubSuccessHttpClient extends BaseClient {
  bool hasBeenCalled = false;
  int callCount = 0;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    hasBeenCalled = true;
    callCount++;
    return StreamedResponse(Stream.empty(), 200);
  }
}

class FullCacheMock extends PassEmploiCacheManager {
  FullCacheMock() : super(DummyConfig());

  @override
  Future<FileInfo?> getFileFromCache(String key, {bool ignoreMemCache = false}) async {
    return FileInfo(
      MockFile(),
      FileSource.Online,
      DateTime.now().add(Duration(days: 1)),
      "je suis un url",
    );
  }
}
