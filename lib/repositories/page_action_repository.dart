import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/page_actions.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_user_action_request.dart';
import 'package:pass_emploi_app/network/put_user_action_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class PageActionRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  PageActionRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<PageActions?> getPageActions(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/home/actions");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return PageActions.fromJson(json);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {
    final url = Uri.parse(_baseUrl + "/actions/$actionId");
    try {
      await _httpClient.put(
        url,
        body: customJsonEncode(PutUserActionRequest(status: newStatus)),
      );
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
  }

  Future<bool> createUserAction(String userId, UserActionCreateRequest request) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/action");
    try {
      final response = await _httpClient.post(
        url,
        body: customJsonEncode(PostUserActionRequest(request)),
      );
      if (response.statusCode.isValid()) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }

  Future<bool> deleteUserAction(String actionId) async {
    final url = Uri.parse(_baseUrl + "/actions/$actionId");
    try {
      final response = await _httpClient.delete(url);
      if (response.statusCode.isValid()) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
