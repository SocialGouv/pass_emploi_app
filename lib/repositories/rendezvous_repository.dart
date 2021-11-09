import 'package:http/http.dart' as http;
import 'package:pass_emploi_app/models/home.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class RendezvousRepository {
  final String baseUrl;
  final HeadersBuilder headerBuilder;

  RendezvousRepository(this.baseUrl, this.headerBuilder);

  Future<List<Rendezvous>?> getRendezvous(String userId) async {
    var url = Uri.parse(baseUrl + "/jeunes/$userId/home");
    try {
      final response = await http.get(url, headers: await headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) return Home.fromJson(jsonUtf8Decode(response.bodyBytes)).rendezvous;
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
