import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/post_user_action_request.dart';
import 'package:pass_emploi_app/network/put_user_action_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class UserActionRepository {
  final String baseUrl;
  final HeadersBuilder headerBuilder;

  UserActionRepository(this.baseUrl, this.headerBuilder);

  Future<List<UserAction>?> getUserActions(String userId) async {
    final url = Uri.parse(baseUrl + "/jeunes/$userId/actions");
    try {
      final response = await http.get(
        url,
        headers: await headerBuilder.headers(userId: userId),
      );
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List).map((action) => UserAction.fromJson(action)).toList();
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }

  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {
    var url = Uri.parse(baseUrl + "/actions/$actionId");
    try {
      http.put(
        url,
        headers: await headerBuilder.headers(userId: userId, contentType: 'application/json'),
        body: customJsonEncode(PutUserActionRequest(status: newStatus)),
      );
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
  }

  Future<bool> createUserAction(String userId, String? content, String? comment, UserActionStatus status) async {
    var url = Uri.parse(baseUrl + "/jeunes/$userId/action");
    try {
      final response = await http.post(
        url,
        headers: await headerBuilder.headers(userId: userId, contentType: 'application/json'),
        body: customJsonEncode(PostUserActionRequest(content: content!, comment: comment, status: status)),
      );
      if (response.statusCode.isValid()) return true;
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return false;
  }

  Future<bool> deleteUserAction(String actionId) async {
    var url = Uri.parse(baseUrl + "/actions/$actionId");
    try {
      final response = await http.delete(
        url,
        headers: await headerBuilder.headers(),
      );
      if (response.statusCode.isValid()) return true;
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return false;
  }
}
