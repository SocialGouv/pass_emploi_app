import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_user_action_request.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class CreateUserActionRepository {
  final String _baseUrl;
  final HeadersBuilder _headersBuilder;

  CreateUserActionRepository(this._baseUrl, this._headersBuilder);

  Future<bool> createUserAction(String userId, String? content, String? comment, UserActionStatus status) async {
    var url = Uri.parse(_baseUrl + "/jeunes/$userId/action");
    try {
      final response = await http.post(
        url,
        headers: await _headersBuilder.headers(userId: userId, contentType: 'application/json'),
        body: customJsonEncode(PostUserActionRequest(content: content!, comment: comment, status: status)),
      );
      if (response.statusCode.isValid()) return true;
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return false;
  }
}