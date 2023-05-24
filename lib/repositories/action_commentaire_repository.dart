import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_action_commentaire.dart';

class ActionCommentaireRepository {
  final Dio _httpClient;
  final PassEmploiCacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  ActionCommentaireRepository(this._httpClient, this._cacheManager, [this._crashlytics]);

  static String getCommentairesUrl({required String actionId}) => '/actions/$actionId/commentaires';

  Future<List<Commentaire>?> getCommentaires(String actionId) async {
    final url = getCommentairesUrl(actionId: actionId);
    try {
      final response = await _httpClient.get(url);
      _cacheManager.removeActionCommentaireResource(actionId);
      return response.asListOf(Commentaire.fromJson);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<bool> sendCommentaire({required String actionId, required String comment}) async {
    final url = getCommentairesUrl(actionId: actionId);
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(PostSendCommentaire(comment)),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
