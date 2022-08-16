import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_action_commentaire.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class ActionCommentaireRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  ActionCommentaireRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<List<Commentaire>?> getCommentaires(String actionId) async {
    final url = Uri.parse(_baseUrl + "/actions/$actionId/commentaires");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List).map((comment) => Commentaire.fromJson(comment)).toList();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<bool> sendCommentaire({required String actionId, required String comment}) async {
    final url = Uri.parse(_baseUrl + "/actions/$actionId/commentaires");
    try {
      final response = await _httpClient.post(
        url,
        body: customJsonEncode(PostSendCommentaire(comment)),
      );
      if (response.statusCode.isValid()) return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}