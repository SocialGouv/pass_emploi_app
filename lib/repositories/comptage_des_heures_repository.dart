import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/comptage_des_heures.dart';

class ComptageDesHeuresRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ComptageDesHeuresRepository(this._httpClient, [this._crashlytics]);

  Future<ComptageDesHeures?> get({
    required String userId,
  }) async {
    final url = "/jeunes/$userId/comptage";
    try {
      if (1 == 1) {
        return ComptageDesHeures(
          nbHeuresValidees: 3,
          nbHeuresDeclarees: 3,
          dateDerniereMiseAJour: DateTime.now().subtract(Duration(days: 1)),
        );
      }
      final response = await _httpClient.get(url);
      // TODO: Remove test
      return ComptageDesHeures.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
