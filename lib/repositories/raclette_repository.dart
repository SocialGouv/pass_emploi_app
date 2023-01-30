import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class RacletteRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  RacletteRepository(this._httpClient, [this._crashlytics]);

  Future<List<String>?> get() async {
    await Future.delayed(Duration(seconds: 2));
    return Random().nextBool() ? ["Raclette", "Fondue", "Chinoise"] : null;
  }
}
