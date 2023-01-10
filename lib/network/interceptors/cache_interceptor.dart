import 'package:dio/dio.dart';
import 'package:pass_emploi_app/network/cache_interceptor.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';

class CacheInterceptor extends Interceptor {
  final PassEmploiCacheManager cacheManager;

  CacheInterceptor(this.cacheManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final stringUrl = options.uri.toString();
    if (options.method != "GET" || !stringUrl.isWhitelisted()) {
      handler.next(options);
      return;
    }

    final fileFromCache = await cacheManager.getFileFromCache(stringUrl);
    if (fileFromCache != null && await fileFromCache.file.exists() && isCacheStillUpToDate(fileFromCache)) {
      handler.resolve(Response(requestOptions: options, data: fileFromCache.file.openRead(), statusCode: 200));
    } else {
      final headers = options.headers.updateAll((key, value) => value.toString()) as Map<String, String>;
      final response = await cacheManager.downloadFile(stringUrl, key: stringUrl, authHeaders: headers);
      handler.resolve(Response(requestOptions: options, data: response.file.openRead(), statusCode: 200));
    }
  }
}
