import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_client.dart';

class PassEmploiMockClient extends BaseClient {
  final Client _httpClient;

  // ignore: ban-name, MockClient is properly decorated
  PassEmploiMockClient(MockClientHandler fn) : _httpClient = ModeDemoValidatorClient(MockClient(fn));

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    try {
      return await _httpClient.send(request);
    } on ModeDemoException catch (e) {
      // ignore: ban-name, debugPrint is required to be displayed in tests' console
      debugPrint(e.toString());
      fail(e.toString());
    }
  }
}
