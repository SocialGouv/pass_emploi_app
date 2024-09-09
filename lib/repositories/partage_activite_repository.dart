import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/preferences.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/put_partage_activite_request.dart';

class PartageActiviteRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  PartageActiviteRepository(this._httpClient, [this._crashlytics]);

  static String getPartageActiviteUrl({required String userId}) => "/jeunes/$userId/preferences";

  Future<Preferences?> getPartageActivite(String userId) async {
    final url = getPartageActiviteUrl(userId: userId);
    try {
      final response = await _httpClient.get(url);

      return Preferences.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<bool> updatePartageActivite(String userId, bool isShare) async {
    final url = getPartageActiviteUrl(userId: userId);
    try {
      await _httpClient.put(
        url,
        data: customJsonEncode(PutPartageActiviteRequest(favoris: isShare)),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
