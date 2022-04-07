import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_user_action_request.dart';
import 'package:pass_emploi_app/network/put_user_action_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class UserActionRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final CacheManager _cacheManager;
  final Crashlytics? _crashlytics;

  UserActionRepository(this._baseUrl, this._httpClient, this._headerBuilder, this._cacheManager, [this._crashlytics]);

  Future<List<UserAction>?> getUserActions(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/actions");
    try {
      final response = await _httpClient.get(
        url,
        headers: await _headerBuilder.headers(userId: userId),
      );
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List).map((action) => UserAction.fromJson(action)).toList();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {
    final url = Uri.parse(_baseUrl + "/actions/$actionId");
    try {
      final response = await _httpClient.put(
        url,
        headers: await _headerBuilder.headers(userId: userId, contentType: 'application/json'),
        body: customJsonEncode(PutUserActionRequest(status: newStatus)),
      );
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
  }

  Future<bool> createUserAction(String userId, String? content, String? comment, UserActionStatus status) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/action");
    try {
      final response = await _httpClient.post(
        url,
        headers: await _headerBuilder.headers(userId: userId, contentType: 'application/json'),
        body: customJsonEncode(PostUserActionRequest(content: content!, comment: comment, status: status)),
      );
      if (response.statusCode.isValid()) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }

  Future<bool> deleteUserAction(String actionId, String userId) async {
    final url = Uri.parse(_baseUrl + "/actions/$actionId");
    try {
      final response = await _httpClient.delete(url, headers: await _headerBuilder.headers());
      if (response.statusCode.isValid()) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
