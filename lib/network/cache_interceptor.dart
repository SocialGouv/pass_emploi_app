import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';

class HttpClientWithCache extends BaseClient {
  final PassEmploiCacheManager cacheManager;
  final Client httpClient;

  HttpClientWithCache(this.cacheManager, this.httpClient);

  @override
  void close() {
    httpClient.close();
  }

  @override
  Future<Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return httpClient.delete(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) async {
    return httpClient.get(url, headers: headers);
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    return httpClient.head(url, headers: headers);
  }

  @override
  Future<Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return httpClient.patch(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return httpClient.post(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return httpClient.put(url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    return httpClient.read(url, headers: headers);
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    return httpClient.readBytes(url, headers: headers);
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final stringUrl = request.url.toString();
    if (request.method == "GET" && stringUrl.isWhitelistedForCache()) {
      final fileFromCache = await cacheManager.getFileFromCache(stringUrl);
      if (fileFromCache != null && await fileFromCache.file.exists() && isCacheStillUpToDate(fileFromCache)) {
        return StreamedResponse(fileFromCache.file.openRead(), 200);
      } else {
        final response = await cacheManager.downloadFile(stringUrl, key: stringUrl, authHeaders: request.headers);
        return StreamedResponse(response.file.openRead(), 200);
      }
    }
    return httpClient.send(request);
  }
}
