import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_actions.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_state.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_details.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi/evenement_emploi_details_repository.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  group('EvenementEmploiDetails', () {
    final sut = StoreSut();

    group("when requesting", () {
      sut.whenDispatchingAction(() => EvenementEmploiDetailsRequestAction("id"));

      test('should load then succeed when request succeed', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.evenementEmploiDetailsRepository = EvenementEmploiDetailsRepositorySuccessStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test('should load then fail when request fail', () {
        sut.givenStore = givenState() //
            .loggedIn()
            .store((f) => {f.evenementEmploiDetailsRepository = EvenementEmploiDetailsRepositoryErrorStub()});

        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<EvenementEmploiDetailsLoadingState>((state) => state.evenementEmploiDetailsState);

Matcher _shouldFail() => StateIs<EvenementEmploiDetailsFailureState>((state) => state.evenementEmploiDetailsState);

Matcher _shouldSucceed() {
  return StateIs<EvenementEmploiDetailsSuccessState>(
    (state) => state.evenementEmploiDetailsState,
    (state) {
      expect(state.details, mockEvenementEmploiDetails());
    },
  );
}

class EvenementEmploiDetailsRepositorySuccessStub extends EvenementEmploiDetailsRepository {
  EvenementEmploiDetailsRepositorySuccessStub() : super(DioMock());

  @override
  Future<EvenementEmploiDetails?> get(String eventId) async {
    return mockEvenementEmploiDetails();
  }
}

class EvenementEmploiDetailsRepositoryErrorStub extends EvenementEmploiDetailsRepository {
  EvenementEmploiDetailsRepositoryErrorStub() : super(DioMock());

  @override
  Future<EvenementEmploiDetails?> get(String eventId) async {
    return null;
  }
}
