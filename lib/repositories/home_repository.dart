import 'package:http/http.dart';
import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class HomeRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;

  HomeRepository(this._baseUrl, this._httpClient, this._headerBuilder);

  Future<Home?> getHome(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/home");
    try {
      final response = await _httpClient.get(
        url,
        headers: await _headerBuilder.headers(userId: userId),
      );
      if (response.statusCode.isValid()) return Home.fromJson(jsonUtf8Decode(response.bodyBytes));
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
