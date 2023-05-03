import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_exception.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_files.dart';
import 'package:pass_emploi_app/utils/asset_bundle_extensions.dart';

class ModeDemoClient extends BaseClient {
  final ModeDemoRepository repository;
  final Client httpClient;

  ModeDemoClient(this.repository, Client httpClient) : httpClient = ModeDemoValidatorClient(httpClient);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    if (!repository.getModeDemo() || !request.url.toString().isSupposedToBeMocked()) return httpClient.send(request);
    if (request.method != "GET") {
      return StreamedResponse(Stream.empty(), 201);
    } else {
      final fileName = getDemoFileName(request.url.path, request.url.query);
      return StreamedResponse(_readFileBytes(fileName!), 200);
    }
  }

  Stream<List<int>> _readFileBytes(String stringUrl) {
    final now = DateTime.now();
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    return rootBundle
        .loadDemoAsset(stringUrl)
        .then(
          (json) => json.replaceAllMapped(
            RegExp(r'(<NOW_PLUS_)(\d+)(>)'),
            (Match m) => dateFormat.format(now.add(Duration(days: int.parse(m[2]!)))),
          ),
        )
        .then(
          (json) => json.replaceAllMapped(
            RegExp(r'(<NOW_LESS_)(\d+)(>)'),
            (Match m) => dateFormat.format(now.subtract(Duration(days: int.parse(m[2]!)))),
          ),
        )
        .then((json) => utf8.encode(json))
        .asStream();
  }
}

class ModeDemoValidatorClient extends BaseClient {
  final Client httpClient;

  ModeDemoValidatorClient(this.httpClient);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    throwModeDemoExceptionIfNecessary(request.method == "GET", request.url);
    return httpClient.send(request);
  }
}
