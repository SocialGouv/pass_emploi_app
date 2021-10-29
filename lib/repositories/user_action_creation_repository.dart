import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_user_action_request.dart';

class UserActionCreationRepository {
  final String _baseUrl;
  final HeadersBuilder _headersBuilder;

  UserActionCreationRepository(this._baseUrl, this._headersBuilder);

  Future<void> createAction(String userId, String? content, String? comment, UserActionStatus status) async {
    var url = Uri.parse(_baseUrl + "/jeunes/$userId/action");
    try {
      http.post(
        url,
        headers: await _headersBuilder.headers(userId: userId, contentType: 'application/json'),
        body: customJsonEncode(PostUserActionRequest(content: content!, comment: comment, status: status)),
      );
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
  }
}