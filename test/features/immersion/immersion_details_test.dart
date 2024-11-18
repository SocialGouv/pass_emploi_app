import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_actions.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';

import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Immersion details', () {
    final sut = StoreSut();
    final repository = MockImmersionDetailsRepository();

    group('when requesting', () {
      sut.whenDispatchingAction(() => ImmersionDetailsRequestAction("id"));

      test('should load then succeed when request succeed', () {
        when(() => repository.fetch('id')).thenAnswer((_) async {
          return OffreDetailsResponse(
            isGenericFailure: false,
            isOffreNotFound: false,
            details: _MockImmersionDetails.instance,
          );
        });

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.immersionDetailsRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        when(() => repository.fetch('id')).thenAnswer((_) async {
          return OffreDetailsResponse(isGenericFailure: true, isOffreNotFound: false, details: null);
        });

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.immersionDetailsRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should load then display incomplete data when request fail but favori is present', () {
        when(() => repository.fetch('id')).thenAnswer((_) async {
          return OffreDetailsResponse(isGenericFailure: false, isOffreNotFound: true, details: null);
        });

        final f = Favori(id: 'id', type: OffreType.immersion, titre: 't', organisation: 'o', localisation: 'l');
        sut.givenStore = givenState() //
            .loggedIn() //
            .favoriListSuccessState([f]) //
            .store((factory) => {factory.immersionDetailsRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedWithIncompleteData()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<ImmersionDetailsLoadingState>((state) => state.immersionDetailsState);

Matcher _shouldFail() => StateIs<ImmersionDetailsFailureState>((state) => state.immersionDetailsState);

Matcher _shouldSucceed() {
  return StateIs<ImmersionDetailsSuccessState>(
    (state) => state.immersionDetailsState,
    (state) => expect(state.immersion, _MockImmersionDetails.instance),
  );
}

Matcher _shouldSucceedWithIncompleteData() {
  return StateIs<ImmersionDetailsIncompleteDataState>(
    (state) => state.immersionDetailsState,
    (state) => expect(state.immersion, _incompleteImmersion()),
  );
}

Immersion _incompleteImmersion() {
  return Immersion(
    id: 'id',
    metier: 't',
    nomEtablissement: 'o',
    secteurActivite: 'Secteur d\'activité inconnu',
    ville: 'l',
  );
}

class _MockImmersionDetails extends Mock implements ImmersionDetails {
  static ImmersionDetails instance = _MockImmersionDetails();
}
