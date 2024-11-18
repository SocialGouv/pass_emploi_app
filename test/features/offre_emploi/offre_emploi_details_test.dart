import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_actions.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Offre Emploi details', () {
    final sut = StoreSut();
    final repository = MockOffreEmploiDetailsRepository();

    group('when requesting', () {
      sut.whenDispatchingAction(() => OffreEmploiDetailsRequestAction("id"));

      test('should load then succeed when request succeed', () {
        when(() => repository.getOffreEmploiDetails(offreId: 'id')).thenAnswer((_) async {
          return OffreDetailsResponse(
            isGenericFailure: false,
            isOffreNotFound: false,
            details: mockOffreEmploiDetails(),
          );
        });

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.detailedOfferRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        when(() => repository.getOffreEmploiDetails(offreId: 'id')).thenAnswer((_) async {
          return OffreDetailsResponse(isGenericFailure: true, isOffreNotFound: false, details: null);
        });

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.detailedOfferRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should load then display incomplete data when request fail but favori is present', () {
        when(() => repository.getOffreEmploiDetails(offreId: 'id')).thenAnswer((_) async {
          return OffreDetailsResponse(isGenericFailure: false, isOffreNotFound: true, details: null);
        });

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.detailedOfferRepository = repository});

        final f = Favori(id: 'id', type: OffreType.immersion, titre: 't', organisation: 'o', localisation: 'l');
        sut.givenStore = givenState() //
            .loggedIn() //
            .favoriListSuccessState([f]) //
            .store((factory) => {factory.detailedOfferRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedWithIncompleteData()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<OffreEmploiDetailsLoadingState>((state) => state.offreEmploiDetailsState);

Matcher _shouldFail() => StateIs<OffreEmploiDetailsFailureState>((state) => state.offreEmploiDetailsState);

Matcher _shouldSucceed() {
  return StateIs<OffreEmploiDetailsSuccessState>(
    (state) => state.offreEmploiDetailsState,
    (state) => expect(state.offre.id, '123TZKB'),
  );
}

Matcher _shouldSucceedWithIncompleteData() {
  return StateIs<OffreEmploiDetailsIncompleteDataState>(
    (state) => state.offreEmploiDetailsState,
    (state) => expect(state.offre, _incompleteOffre()),
  );
}

OffreEmploi _incompleteOffre() {
  return OffreEmploi(
    id: 'id',
    title: 't',
    companyName: 'o',
    contractType: 'Type de contrat inconnu',
    isAlternance: false,
    location: 'l',
    duration: null,
    origin: null,
  );
}
