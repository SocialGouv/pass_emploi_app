import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class AccueilRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  AccueilRepository(this._httpClient, [this._crashlytics]);

  Future<bool?> get() async {
    final url = "/jeunes/todo";
    try {
      final response = await _httpClient.get(url);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
