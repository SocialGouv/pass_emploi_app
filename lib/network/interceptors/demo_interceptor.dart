import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pass_emploi_app/features/mode_demo/is_mode_demo_repository.dart';

class DemoInterceptor extends Interceptor {
  final ModeDemoRepository demoRepository;

  DemoInterceptor(this.demoRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!demoRepository.getModeDemo()) handler.next(options);
    handler.resolve(Response(requestOptions: options, data: await readFile("home_actions")));
  }

  Future<dynamic> readFile(String stringUrl) async {
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
