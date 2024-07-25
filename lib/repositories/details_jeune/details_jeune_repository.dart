import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/patch_details_jeune.dart';

class DetailsJeuneRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  DetailsJeuneRepository(this._httpClient, [this._crashlytics]);

  Future<DetailsJeune?> get(String userId) async {
    final url = "/jeunes/$userId";
    try {
      final response = await _httpClient.get(url);
      return DetailsJeune.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<bool> patch(String userId, DateTime dateSignatureCgu) async {
    final url = "/jeunes/$userId";
    try {
      await _httpClient.patch(
        url,
        data: customJsonEncode(PatchDetailsJeune(dateSignatureCgu)),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
