import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class ModuleFeedbackRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ModuleFeedbackRepository(this._httpClient, [this._crashlytics]);

  Future<bool?> post({required String tag, required int note, required String commentaire}) async {
    final url = "/feedbacks/evaluer";
    try {
      await _httpClient.post(url, data: {
        "tag": tag,
        "note": note,
        "commentaire": commentaire,
      });
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
