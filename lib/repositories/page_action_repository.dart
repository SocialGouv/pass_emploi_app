import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/page_actions.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_user_action_request.dart';
import 'package:pass_emploi_app/network/put_user_action_request.dart';

sealed class UserActionCreation {
  final String userActionId;

  UserActionCreation(this.userActionId);
}

class LocalUserActionCreation extends UserActionCreation {
  LocalUserActionCreation(String userActionId) : super(userActionId);
}

class RemoteUserActionCreation extends UserActionCreation {
  RemoteUserActionCreation(String userActionId) : super(userActionId);
}

class PageActionRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  PageActionRepository(this._httpClient, [this._crashlytics]);

  Future<PageActions?> getPageActions(String userId) async {
    final url = '/jeunes/$userId/home/actions';
    try {
      final response = await _httpClient.get(url);
      return PageActions.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<bool> updateActionStatus(String actionId, UserActionStatus newStatus) async {
    final url = '/actions/$actionId';
    try {
      await _httpClient.put(
        url,
        data: customJsonEncode(PutUserActionRequest(status: newStatus)),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }

  Future<UserActionCreation?> createUserAction(String userId, UserActionCreateRequest request) async {
    final url = '/jeunes/$userId/action';
    try {
      final response = await _httpClient.post(
        url,
        data: customJsonEncode(PostUserActionRequest(request)),
      );
      final userActionId = response.data['id'] as String;
      final local = (response.data['local'] as bool?) ?? false;
      return local ? LocalUserActionCreation(userActionId) : RemoteUserActionCreation(userActionId);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<bool> deleteUserAction(String actionId) async {
    final url = '/actions/$actionId';
    try {
      await _httpClient.delete(url);
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
