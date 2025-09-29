import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/network/interceptors/cache_interceptor.dart';

void main() {
  late MockDioCacheInterceptor decorated;
  late CacheInterceptor cacheInterceptor;
  late MockRequestInterceptorHandler requestHandler;
  late MockResponseInterceptorHandler responseHandler;
  late MockErrorInterceptorHandler errorHandler;

  setUp(() {
    decorated = MockDioCacheInterceptor();
    cacheInterceptor = CacheInterceptor(decorated);
    requestHandler = MockRequestInterceptorHandler();
    responseHandler = MockResponseInterceptorHandler();
    errorHandler = MockErrorInterceptorHandler();
  });

  test('for non blacklisted routes, cache should be used', () {
    // Given
    final options = RequestOptions(baseUrl: 'https://api.passemploi.fr', path: '/accueil');
    final response = Response(requestOptions: options);
    final error = DioException(requestOptions: options);

    // When
    cacheInterceptor.onPassEmploiRequest(options, requestHandler);
    cacheInterceptor.onPassEmploiResponse(response, responseHandler);
    cacheInterceptor.onPassEmploiError(error, errorHandler);

    // Then
    verify(() => decorated.onRequest(options, requestHandler)).called(1);
    verify(() => decorated.onResponse(response, responseHandler)).called(1);
    verify(() => decorated.onError(error, errorHandler)).called(1);
    verifyNever(() => requestHandler.next(options));
    verifyNever(() => responseHandler.next(response));
    verifyNever(() => errorHandler.next(error));
  });

  test('for GET/mon-suivi route, cache should NOT used, as not pull to refresh mechanism is setup yet', () {
    // Given
    final options = RequestOptions(baseUrl: 'https://api.passemploi.fr', path: '/mon-suivi');
    final response = Response(requestOptions: options);
    final error = DioException(requestOptions: options);

    // When
    cacheInterceptor.onPassEmploiRequest(options, requestHandler);
    cacheInterceptor.onPassEmploiResponse(response, responseHandler);
    cacheInterceptor.onPassEmploiError(error, errorHandler);

    // Then
    verifyNever(() => decorated.onRequest(options, requestHandler));
    verifyNever(() => decorated.onResponse(response, responseHandler));
    verifyNever(() => decorated.onError(error, errorHandler));
    verify(() => requestHandler.next(options)).called(1);
    verify(() => responseHandler.next(response)).called(1);
    verify(() => errorHandler.next(error)).called(1);
  });
}

class MockDioCacheInterceptor extends Mock implements DioCacheInterceptor {}

class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}
