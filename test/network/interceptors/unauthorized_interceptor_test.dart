import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/network/interceptors/unauthorized_interceptor.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/spies.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late UnauthorizedInterceptor interceptor;
  late MockInterceptorHandler interceptorHandler;
  late MockStore mockStore;

  setUp(() {
    interceptor = UnauthorizedInterceptor();
    interceptorHandler = MockInterceptorHandler();
    mockStore = MockStore();
  });

  test('increments unauthorizedCount on 401 error', () {
    // Given
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: Response(statusCode: 401, requestOptions: RequestOptions(path: '/test')),
    );
    interceptor.setStore(mockStore);

    // When
    interceptor.onPassEmploiError(dioError, interceptorHandler);

    // Then
    expect(interceptor.unauthorizedCount, 1);
    verifyNever(() => mockStore.dispatch(any));
  });

  test('dispatches RequestLogoutAction when limit is exceeded', () {
    // Given
    interceptor.unauthorizedCount = UnauthorizedInterceptor.unauthorizedCountLimit - 1;
    final store = StoreSpy();
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: Response(statusCode: 401, requestOptions: RequestOptions(path: '/test')),
    );
    interceptor.setStore(store);

    // When
    interceptor.onPassEmploiError(dioError, interceptorHandler);

    // Then
    expect(interceptor.unauthorizedCount, UnauthorizedInterceptor.unauthorizedCountLimit);
    expect(store.dispatchedAction, isA<RequestLogoutAction>());
  });

  test('does not increment unauthorizedCount for non-401 errors', () {
    // Given
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: Response(statusCode: 500, requestOptions: RequestOptions(path: '/test')),
    );
    interceptor.setStore(mockStore);

    // When
    interceptor.onPassEmploiError(dioError, interceptorHandler);

    // Then
    expect(interceptor.unauthorizedCount, 0);
    verifyNever(() => mockStore.dispatch(any));
  });
}
