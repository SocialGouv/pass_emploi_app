import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/patch_user_action_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class UserActionRepository {
  final String baseUrl;
  final HeadersBuilder headerBuilder;

  UserActionRepository(this.baseUrl, this.headerBuilder);

  Future<List<UserAction>?> getUserActions(String userId) async {
    var url = Uri.parse(baseUrl + "/jeunes/$userId/actions");
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

  Future<void> updateActionStatus(String userId, String actionId, bool newIsDoneValue) async {
    var url = Uri.parse(baseUrl + "/actions/$actionId");
    try {
      http.patch(
        url,
        headers: await headerBuilder.headers(userId: userId, contentType: 'application/json'),
        body: customJsonEncode(PatchUserActionRequest(isDone: newIsDoneValue)),
      );
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
  }
}
