import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_create_demarche.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class CreateDemarcheRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  CreateDemarcheRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<bool> createDemarche({
    required String userId,
    required String codeQuoi,
    required String codePourquoi,
    required String? codeComment,
    required DateTime dateEcheance,
  }) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/demarches");
    try {
      final response = await _httpClient.post(
        url,
        body: customJsonEncode(
          PostCreateDemarche(
            codeQuoi: codeQuoi,
            codePourquoi: codePourquoi,
            codeComment: codeComment,
            dateEcheance: dateEcheance,
          ),
        ),
      );
      if (response.statusCode.isValid()) return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }

  Future<bool> createDemarchePersonnalisee({
    required String userId,
    required String commentaire,
    required DateTime dateEcheance,
  }) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/demarches");
    try {
      final response = await _httpClient.post(
        url,
        body: customJsonEncode(PostCreateDemarchePersonnalisee(commentaire, dateEcheance)),
      );
      if (response.statusCode.isValid()) return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
