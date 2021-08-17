import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/patch_user_action_request.dart';

class HomeRepository {
  final String baseUrl;

  HomeRepository(this.baseUrl);

  Future<Home?> getHome(String userId) async {
    var url = Uri.parse(baseUrl + "/jeunes/$userId/home");
    try {
      final response = await http.get(url);
      return Home.fromJson(jsonUtf8Decode(response.bodyBytes));
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
      return null;
    }
  }

  //TODO Change put to PATCH
  void updateActionStatus(String actionId, bool newIsDoneValue) {
    var url = Uri.parse(baseUrl + "/actions/$actionId");
    try {
      http.put(
        url,
        body: customJsonEncode(PatchUserActionRequest(isDone: newIsDoneValue)),
      );
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
  }
}
