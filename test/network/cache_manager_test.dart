import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/network/cache_manager.dart';

void main() {
  group('CachedResource', () {
    group('milo', () {
      test('should return all sessions when no filter', () {
        // Given
        const String url = "/jeunes/milo/dummyUserId/sessions";

        // When
        final result = CachedResource.fromUrl(url);

        // Then
        expect(result, CachedResource.sessionsMiloList);
      });

      test('should return only sessions where jeune is inscrit when filter is true', () {
        // Given
        const String url = "/jeunes/milo/dummyUserId/sessions?filtrerEstInscrit=true";

        // When
        final result = CachedResource.fromUrl(url);

        // Then
        expect(result, CachedResource.sessionsMiloInscrit);
      });

      test('should return only sessions where jeune is not inscrit when filter is false', () {
        // Given
        const String url = "/jeunes/milo/dummyUserId/sessions?filtrerEstInscrit=false";

        // When
        final result = CachedResource.fromUrl(url);

        // Then
        expect(result, CachedResource.sessionsMiloNonInscrit);
      });

      test('should return nothing when url is get session details', () {
        // Given
        const String url = "/jeunes/milo/dummyUserId/sessions/dummySessionId";

        // When
        final result = CachedResource.fromUrl(url);

        // Then
        expect(result, null);
      });
    });
  });
}
