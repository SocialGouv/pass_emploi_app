import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_details_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository.dart';
import '../utils/mock_demo_client.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';

void main() {
  final sut = RepositorySut<OffreEmploiDetailsRepository>();
  sut.givenRepository((client) => OffreEmploiDetailsRepository("BASE_URL", client));

  group("getOffreEmploiDetails", () {
    sut.when((repository) => repository.getOffreEmploiDetails(offreId: "ID"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "offre_emploi_details.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/offres-emploi/ID",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<OffreDetailsResponse<OffreEmploiDetails>?>((result) {
          expect(result?.details, isNotNull);
          expect(result?.details, mockOffreEmploiDetails());
          expect(result?.isGenericFailure, isFalse);
          expect(result?.isOffreNotFound, isFalse);
        });
      });
    });

    group('when response is invalid', () {
      sut.given500Response();

      test('should flag response as not found', () async {
        await sut.expectResult<OffreDetailsResponse<OffreEmploiDetails>?>((result) {
          expect(result?.details, isNull);
          expect(result?.isGenericFailure, isFalse);
          expect(result?.isOffreNotFound, isTrue);
        });
      });
    });

    group('when response throws exception', () {
      sut.givenThrowingExceptionResponse();

      test('should flag response as generic failure', () async {
        await sut.expectResult<OffreDetailsResponse<OffreEmploiDetails>?>((result) {
          expect(result?.details, isNull);
          expect(result?.isGenericFailure, isTrue);
          expect(result?.isOffreNotFound, isFalse);
        });
      });
    });

    group('when response throws 404 exception', () {
      sut.givenResponse(() => throw deletedOfferHttpResponse());

      test('should flag response as not found', () async {
        await sut.expectResult<OffreDetailsResponse<OffreEmploiDetails>?>((result) {
          expect(result?.details, isNull);
          expect(result?.isGenericFailure, isFalse);
          expect(result?.isOffreNotFound, isTrue);
        });
      });
    });
  });

  // TODO ?
  test('getOffreEmploiDetails when mode demo', () async {
    // Given
    final httpClient = MockModeDemoClient();
    final repository = OffreEmploiDetailsRepository("BASE_URL", httpClient);

    // When
    final offre = await repository.getOffreEmploiDetails(offreId: "ID");

    // Then
    expect(offre.details, isNotNull);
  });
}
