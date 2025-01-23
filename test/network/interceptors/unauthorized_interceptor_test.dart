import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/network/interceptors/unauthorized_interceptor.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/spies.dart';

class MockStore extends Mock implements Store<AppState> {}

class MockInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

class MockRemoteConfigRepository extends Mock implements RemoteConfigRepository {
  void withUnhautorizedLimitAt(int? limit) {
    when(() => maxUnauthorizedErrorsBeforeLogout()).thenReturn(limit);
  }
}

void main() {
  late UnauthorizedInterceptor interceptor;
  late MockInterceptorHandler interceptorHandler;
  late MockRemoteConfigRepository remoteConfigRepository;
  late MockStore mockStore;

  setUp(() {
    remoteConfigRepository = MockRemoteConfigRepository();
    interceptor = UnauthorizedInterceptor(remoteConfigRepository);
    interceptorHandler = MockInterceptorHandler();
    mockStore = MockStore();
  });

  test('should do nothing when unauthorized limit is null', () {
    // Given
    remoteConfigRepository.withUnhautorizedLimitAt(null);
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: Response(statusCode: 401, requestOptions: RequestOptions(path: '/test')),
    );
    interceptor.setStore(mockStore);

    // When
    interceptor.onPassEmploiError(dioError, interceptorHandler);

    // Then
    expect(interceptor.unauthorizedCount, 0);
    verifyNever(() => mockStore.dispatch(any));
  });

  test('increments unauthorizedCount on 401 error', () {
    // Given
    remoteConfigRepository.withUnhautorizedLimitAt(10);
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
    remoteConfigRepository.withUnhautorizedLimitAt(1);
    final store = StoreSpy();
    final dioError = DioException(
      requestOptions: RequestOptions(path: '/test'),
      response: Response(statusCode: 401, requestOptions: RequestOptions(path: '/test')),
    );
    interceptor.setStore(store);

    // When
    interceptor.onPassEmploiError(dioError, interceptorHandler);

    // Then
    expect(interceptor.unauthorizedCount, 1);
    expect(store.dispatchedAction, isA<RequestLogoutAction>());
  });

  test('reset unauthorizedCount for non-401 errors', () {
    // Given
    remoteConfigRepository.withUnhautorizedLimitAt(10);
    interceptor.unauthorizedCount = 5;
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
