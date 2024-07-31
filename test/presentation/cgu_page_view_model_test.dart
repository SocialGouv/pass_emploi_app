import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/cgu/cgu_actions.dart';
import 'package:pass_emploi_app/models/cgu.dart';
import 'package:pass_emploi_app/presentation/cgu_page_view_model.dart';

import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('create when CGU never accepted', () {
    // Given
    final store = givenState().withCguNeverAccepted().store();

    // When
    final viewModel = CguPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, CguNeverAcceptedDisplayState());
  });

  test('create when CGU update required', () {
    // Given
    final store = givenState()
        .withCguUpdateRequired(
          Cgu(
            lastUpdate: DateTime(2024, 1, 2),
            changes: ['change 1', 'change 2'],
          ),
        )
        .store();

    // When
    final viewModel = CguPageViewModel.create(store);

    // Then
    expect(
      viewModel.displayState,
      CguUpdateRequiredDisplayState(
        lastUpdateLabel: '02 janvier 2024',
        changes: ['change 1', 'change 2'],
      ),
    );
  });

  test('onAccept should dispatch CguAcceptedAction', () {
    withClock(Clock.fixed(DateTime(2024, 7, 7)), () {
      // Given
      final store = StoreSpy();
      final viewModel = CguPageViewModel.create(store);

      // When
      viewModel.onAccept();

      // Then
      expect(store.dispatchedAction, isA<CguAcceptedAction>());
      expect((store.dispatchedAction as CguAcceptedAction).date, DateTime(2024, 7, 7));
    });
  });

  test('onRefuse should dispatch CguRefusedAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = CguPageViewModel.create(store);

    // When
    viewModel.onRefuse();

    // Then
    expect(store.dispatchedAction, isA<CguRefusedAction>());
  });
}
