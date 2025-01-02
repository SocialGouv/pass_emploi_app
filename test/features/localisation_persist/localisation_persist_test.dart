import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/features/bootstrap/bootstrap_action.dart';
import 'package:pass_emploi_app/features/localisation_persist/localisation_persist_actions.dart';
import 'package:pass_emploi_app/features/localisation_persist/localisation_persist_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(mockLocation());
  });

  group('LocalisationPersist', () {
    final sut = StoreSut();
    final repository = MockLocalisationPersistRepository();

    group("when bootstraping", () {
      sut.whenDispatchingAction(() => BootstrapAction());

      test('should load then succeed when request succeeds', () {
        when(() => repository.get()).thenAnswer((_) async => mockLocation());

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.localisationPersistRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed()]);
      });
    });

    group('when writing location', () {
      sut.whenDispatchingAction(() => LocalisationPersistWriteAction(mockLocation()));

      test('should write location', () {
        when(() => repository.save(any())).thenAnswer((_) async {});

        sut.givenStore = givenState() //
            .loggedInUser()
            .store((f) => {f.localisationPersistRepository = repository});

        sut.thenExpectChangingStatesThroughOrder([_shouldSucceed()]);
      });
    });
  });
}

Matcher _shouldSucceed() {
  return StateIs<LocalisationPersistSuccessState>(
    (state) => state.localisationPersistState,
    (state) {
      expect(state.result, mockLocation());
    },
  );
}
