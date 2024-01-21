import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pass_emploi_app/auth/auth_access_checker.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/interceptors/auth_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/cache_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/demo_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/expired_token_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/logging_interceptor.dart';
import 'package:pass_emploi_app/network/interceptors/monitoring_interceptor.dart';

class PassEmploiDioBuilder {
  final String baseUrl;
  final CacheStore cacheStore;
  final ModeDemoRepository modeDemoRepository;
  final AuthAccessTokenRetriever accessTokenRetriever;
  final AuthAccessChecker authAccessChecker;
  final MonitoringInterceptor monitoringInterceptor;

  PassEmploiDioBuilder({
    required this.baseUrl,
    required this.cacheStore,
    required this.modeDemoRepository,
    required this.accessTokenRetriever,
    required this.authAccessChecker,
    required this.monitoringInterceptor,
  });

  Dio build() {
    final cacheOptions = CacheOptions(
      store: cacheStore,
      hitCacheOnErrorExcept: [401, 403, 404],
      policy: CachePolicy.request,
      keyBuilder: (request) => PassEmploiCacheManager.getCacheKey(request.uri.toString()),
    );
    final dioClient = Dio(BaseOptions(baseUrl: baseUrl));
    dioClient.interceptors
      ..add(DemoInterceptor(modeDemoRepository))
      ..add(monitoringInterceptor)
      ..add(AuthInterceptor(accessTokenRetriever))
      ..add(CacheInterceptor(DioCacheInterceptor(options: cacheOptions)))
      ..add(LoggingNetworkInterceptor())
      ..add(ExpiredTokenInterceptor(authAccessChecker));
    return dioClient;
  }
}
