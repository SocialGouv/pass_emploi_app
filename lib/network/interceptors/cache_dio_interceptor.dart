import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/utils/log.dart';

class CacheDioInterceptor extends Interceptor {
  final PassEmploiCacheManager cacheManager;

  CacheDioInterceptor(this.cacheManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final stringUrl = options.uri.toString();
    if (options.method != "GET" || !stringUrl.isWhitelistedForCache()) {
      handler.next(options);
      return;
    }

    final fileFromCache = await cacheManager.getFileFromCache(stringUrl);
    if (fileFromCache != null && await fileFromCache.file.exists() && isCacheStillUpToDate(fileFromCache)) {
      Log.i("Intercepting cache request for ${options.uri.path} : return cached data.");
      handler.resolve(await _response(options, fileFromCache.file));
    } else {
      Log.i("Intercepting cache request for ${options.uri.path} : return fresh data.");
      final headers = options.headers.map((key, value) => MapEntry(key, value.toString()));
      await cacheManager
          .downloadFile(stringUrl, key: stringUrl, authHeaders: headers)
          .then((downloadedFile) => _response(options, downloadedFile.file))
          .then((response) => handler.resolve(response))
          .catchError((e) => handler.reject(DioError(requestOptions: options, error: e)));
    }
  }
}

Future<Response<dynamic>> _response(RequestOptions options, File file) async {
  final decodedData = await utf8.decodeStream(file.openRead());
  final json = jsonDecode(decodedData);
  return Response(requestOptions: options, data: json, statusCode: 200);
}
