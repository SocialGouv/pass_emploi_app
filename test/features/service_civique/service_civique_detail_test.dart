import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_actions.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_details_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('Service Civique details', () {
    final sut = StoreSut();
    final repository = MockServiceCiviqueDetailRepository();

    group("when requesting", () {
      sut.whenDispatchingAction(() => GetServiceCiviqueDetailAction("id"));

      test('should load then succeed when request succeed', () {
        when(() => repository.getServiceCiviqueDetail('id'))
            .thenAnswer((_) async => SuccessfullServiceCiviqueDetailResponse(mockServiceCiviqueDetail()));

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.serviceCiviqueDetailRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        when(() => repository.getServiceCiviqueDetail('id'))
            .thenAnswer((_) async => FailedServiceCiviqueDetailResponse());

        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.serviceCiviqueDetailRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });

      test('should load then display incomplete data when request fail but favori is present', () {
        when(() => repository.getServiceCiviqueDetail('id'))
            .thenAnswer((_) async => NotFoundServiceCiviqueDetailResponse());

        final f = Favori(id: 'id', type: OffreType.serviceCivique, titre: 't', organisation: 'o', localisation: 'l');
        sut.givenStore = givenState() //
            .loggedIn() //
            .favoriListSuccessState([f]) //
            .store((factory) => {factory.serviceCiviqueDetailRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceedWithIncompleteData()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<ServiceCiviqueDetailLoadingState>((state) => state.serviceCiviqueDetailState);

Matcher _shouldFail() => StateIs<ServiceCiviqueDetailFailureState>((state) => state.serviceCiviqueDetailState);

Matcher _shouldSucceed() {
  return StateIs<ServiceCiviqueDetailSuccessState>(
    (state) => state.serviceCiviqueDetailState,
    (state) => expect(state.detail, mockServiceCiviqueDetail()),
  );
}

Matcher _shouldSucceedWithIncompleteData() {
  return StateIs<ServiceCiviqueDetailNotFoundState>(
    (state) => state.serviceCiviqueDetailState,
    (state) => expect(state.serviceCivique, _incompleteServiceCivique()),
  );
}

ServiceCivique _incompleteServiceCivique() {
  return ServiceCivique(
    id: 'id',
    title: 't',
    companyName: 'o',
    location: 'l',
    domain: null,
    startDate: null,
  );
}
