import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/interceptors/pass_emploi_base_dio_interceptor.dart';
import 'package:pass_emploi_app/utils/log.dart';

class CacheDioInterceptor extends PassEmploiBaseDioInterceptor {
  final PassEmploiCacheManager cacheManager;

  CacheDioInterceptor(this.cacheManager);

  @override
  void onPassEmploiRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final stringUrl = options.uri.toString();
    if (options.method != "GET" || !stringUrl.isWhitelistedForCache()) {
      handler.next(options);
      return;
    }

    final cacheKey = CachedResource.fromUrl(stringUrl)?.toString() ?? stringUrl;
    final fileFromCache = await cacheManager.getFileFromCache(cacheKey);
    if (fileFromCache != null && await fileFromCache.file.exists() && isCacheStillUpToDate(fileFromCache)) {
      Log.i("""Dio Request - cache interceptor - return cached data
      - ${options.method} ${options.uri.toString()}
      - queryParams: ${options.queryParameters}
      - headers: ${options.headers}
      """);
      handler.resolve(await _response(options, fileFromCache.file), true);
    } else {
      Log.i("""Dio Request - cache interceptor - return fresh data
      - ${options.method} ${options.uri.toString()}
      - queryParams: ${options.queryParameters}
      - headers: ${options.headers}
      """);
      final headers = options.headers.map((key, value) => MapEntry(key, value.toString()));
      await cacheManager
          .downloadFile(stringUrl, key: cacheKey, authHeaders: headers)
          .then((downloadedFile) => _response(options, downloadedFile.file))
          .then((response) => handler.resolve(response, true))
          .catchError((e) => temporaryResolveHttpException(e, handler, options));
    }
  }

  // Rustine en attendant de gérer le cache DIFFEREMMENT
  void temporaryResolveHttpException(e, RequestInterceptorHandler handler, RequestOptions options) {
    if (e is HttpExceptionWithStatus && e.statusCode == 401) {
      handler.next(options);
    } else {
      handler.reject(DioError(requestOptions: options, error: e), true);
    }
  }
}

Future<Response<dynamic>> _response(RequestOptions options, File file) async {
  final decodedData = await utf8.decodeStream(file.openRead());
  final json = jsonDecode(decodedData);
  return Response(requestOptions: options, data: json, statusCode: 200);
}
