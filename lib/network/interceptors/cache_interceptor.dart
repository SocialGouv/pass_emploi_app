import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {

  CacheInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // final stringUrl = options.



    // if (request.method == "GET" && stringUrl.isWhitelisted()) {
    //   final fileFromCache = await cacheManager.getFileFromCache(stringUrl);
    //   if (fileFromCache != null && await fileFromCache.file.exists() && _isStillUpToDate(fileFromCache)) {
    //     return StreamedResponse(fileFromCache.file.openRead(), 200);
    //   } else {
    //     final response = await cacheManager.downloadFile(stringUrl, key: stringUrl, authHeaders: request.headers);
    //     return StreamedResponse(response.file.openRead(), 200);
    //   }
    // }
    // return httpClient.send(request);
  }
}
