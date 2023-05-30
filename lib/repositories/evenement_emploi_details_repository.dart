import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/evenement_emploi_details.dart';

class EvenementEmploiDetailsRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  EvenementEmploiDetailsRepository(this._httpClient, [this._crashlytics]);

  Future<EvenementEmploiDetails?> get() async {
    final url = "/jeunes/todo";
    try {
      final response = await _httpClient.get(url);
      return null;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
