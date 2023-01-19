import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_exception.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_files.dart';
import 'package:pass_emploi_app/utils/log.dart';

class DemoDioInterceptor extends Interceptor {
  final ModeDemoRepository demoRepository;

  DemoDioInterceptor(this.demoRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    throwModeDemoExceptionIfNecessary(options.method == "GET", options.uri);

    if (!demoRepository.getModeDemo() || !options.uri.toString().isSupposedToBeMocked()) {
      handler.next(options);
      return;
    }

    Log.i("Intercepting demo request for ${options.uri.path}.");
    final demoFileName = getDemoFileName(options.uri.path, options.uri.query);
    if (options.method == "GET") {
      handler.resolve(Response(requestOptions: options, data: await _readFile(demoFileName!), statusCode: 200));
    } else {
      handler.resolve(Response(requestOptions: options, statusCode: 201));
    }
  }

  Future<dynamic> _readFile(String stringUrl) async {
    final now = DateTime.now();
    final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    return rootBundle
        .loadString("assets/mode_demo/" + stringUrl + ".json")
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
        .then((json) => jsonDecode(json));
  }
}