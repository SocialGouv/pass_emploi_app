import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/interceptors/logout_after_too_many_401_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/monitoring_interceptor.dart';
import 'package:pass_emploi_app/network/pass_emploi_dio_builder.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/app_version_repository.dart';
import 'package:pass_emploi_app/repositories/installation_id_repository.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';
import 'package:redux/redux.dart';

void main() {
  const path = '/milo/accueil';
  const responseData = {'message': 'Success!'};

  late Dio dio;
  late MockCacheStore cacheStore;
  late MockModeDemoRepository modeDemoRepository;
  late MockAuthAccessTokenRetriever accessTokenRetriever;
  late MockAuthAccessChecker authAccessChecker;
  late MockRemoteConfigRepository remoteConfigRepository;
  late MonitoringInterceptor monitoringInterceptor;
  late LogoutAfterTooMany401Interceptor unauthorizedInterceptor;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    cacheStore = MockCacheStore();
    modeDemoRepository = MockModeDemoRepository();
    accessTokenRetriever = MockAuthAccessTokenRetriever();
    authAccessChecker = MockAuthAccessChecker();
    monitoringInterceptor = DummyMonitoringInterceptor();
    remoteConfigRepository = MockRemoteConfigRepository();
    unauthorizedInterceptor = LogoutAfterTooMany401Interceptor(remoteConfigRepository);
    dio = PassEmploiDioBuilder(
      baseUrl: "https://api.test.fr",
      cacheStore: cacheStore,
      modeDemoRepository: modeDemoRepository,
      accessTokenRetriever: accessTokenRetriever,
      authAccessChecker: authAccessChecker,
      monitoringInterceptor: monitoringInterceptor,
      unauthorizedInterceptor: unauthorizedInterceptor,
    ).build();
    DioAdapter(dio: dio).onGet(path, (server) => server.reply(200, responseData));
  });

  test('full test', () async {
    // Given
    accessTokenRetriever.withAccessToken();

    // When
    final response = await dio.get(path);

    // Then
    expect(response.data, responseData);
  });

  test('when access token throws exception should handle it and forward to next interceptors to return cached data',
      () async {
    // Given
    accessTokenRetriever.throwException();

    // When
    try {
      await dio.get(path);
    } catch (_) {}

    // Then
    verify(() => cacheStore.get(PassEmploiCacheManager.getCacheKey(path))).called(1);
  });

  test('should add bearer', () async {
    // Given
    accessTokenRetriever.withAccessToken();

    // When
    final response = await dio.get(path);

    // Then
    expect(response.requestOptions.headers['Authorization'], 'Bearer accessToken');
  });

  test('should add monitoring info', () async {
    // Given
    accessTokenRetriever.withAccessToken();

    // When
    final response = await dio.get(path);

    // Then
    expect(response.requestOptions.headers['X-UserId'], 'NOT_LOGIN_USER');
    expect(response.requestOptions.headers['X-InstallationId'], 'installation-id');
    expect(response.requestOptions.headers['X-AppVersion'], '1.0.0');
    expect(response.requestOptions.headers['X-CorrelationId'], isNotNull);
    expect(response.requestOptions.headers['X-Platform'], isNotNull);
  });
}

class MockCacheStore extends Mock implements CacheStore {
  MockCacheStore() {
    when(() => get(any())).thenAnswer((_) async => null);
  }
}

class MockModeDemoRepository extends Mock implements ModeDemoRepository {
  MockModeDemoRepository() {
    when(() => isModeDemo()).thenReturn(false);
  }
}

class MockAuthAccessTokenRetriever extends Mock implements AuthAccessTokenRetriever {
  void withAccessToken() {
    when(() => accessToken()).thenAnswer((_) async => 'accessToken');
  }

  void throwException() {
    when(() => accessToken()).thenThrow(Exception());
  }
}

class MockAuthAccessChecker extends Mock implements AuthAccessChecker {}

class MockUnauthorizedInterceptor extends Mock implements LogoutAfterTooMany401Interceptor {
  MockUnauthorizedInterceptor() {
    setStore(DummyStore());
  }
}

class DummyMonitoringInterceptor extends MonitoringInterceptor {
  DummyMonitoringInterceptor() : super(MockInstallationIdRepository(), MockAppVersionRepository()) {
    setStore(DummyStore());
  }
}

class MockInstallationIdRepository extends Mock implements InstallationIdRepository {
  MockInstallationIdRepository() {
    when(() => getInstallationId()).thenAnswer((_) async => "installation-id");
  }
}

class MockAppVersionRepository extends Mock implements AppVersionRepository {
  MockAppVersionRepository() {
    when(() => getAppVersion()).thenAnswer((_) async => "1.0.0");
  }
}

class DummyStore extends Store<AppState> {
  DummyStore() : super((state, dynamic action) => state, initialState: AppState.initialState());
}

class MockRemoteConfigRepository extends Mock implements RemoteConfigRepository {}
