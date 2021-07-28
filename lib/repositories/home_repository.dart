import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';

class HomeRepository {
  final String baseUrl;

  HomeRepository(this.baseUrl);

  Future<Home?> getHome(String userId) async {
    var url = Uri.parse(baseUrl + "/jeunes/$userId/home");
    try {
      final response = await http.get(url);
      return Home.fromJson(jsonUtf8Decode(response.bodyBytes));
    } catch (e) {
      return null;
    }
  }
}
