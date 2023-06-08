import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_repository2.dart';

void main() {
  final sut = RepositorySut2<OffreEmploiDetailsRepository>();
  sut.givenRepository((client) => OffreEmploiDetailsRepository(client));

  group("getOffreEmploiDetails", () {
    sut.when((repository) => repository.getOffreEmploiDetails(offreId: "ID"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "offre_emploi_details.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: "/offres-emploi/ID",
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
      sut.givenResponseCode(500);

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
      sut.givenResponseCode(404);

      test('should flag response as not found', () async {
        await sut.expectResult<OffreDetailsResponse<OffreEmploiDetails>?>((result) {
          expect(result?.details, isNull);
          expect(result?.isGenericFailure, isFalse);
          expect(result?.isOffreNotFound, isTrue);
        });
      });
    });
  });
}
