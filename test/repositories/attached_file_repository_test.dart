import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/repositories/attached_file_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';

void main() {
  test('getAttachedFile', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/files/ID")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("attached_file.json"), 200);
    });
    final repository = AttachedFileRepository("BASE_URL", httpClient);

    // When
    final result = await repository.download(fileId: "ID", fileExtension: "png");

    // Then
    expect(result, isNotNull);
    expect(result, "https://www.messagerbenin.info/wp-content/uploads/2021/06/14481-google-logo-3-s-.jpg");

  });

  test('getAttachedFile when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = AttachedFileRepository("BASE_URL", httpClient);

    // When
    final result = await repository.download(fileId: "ID", fileExtension: "png");

    // Then
    expect(result, isNull);
  });
}
