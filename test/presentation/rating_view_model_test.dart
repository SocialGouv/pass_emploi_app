import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/rating/rating_actions.dart';
import 'package:pass_emploi_app/presentation/rating_view_model.dart';
import '../doubles/spies.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('should set show to TRUE if ShowRatingState', () {
    // Given
    final store = givenState().showRating().store();

    // When
    final viewModel = RatingViewModel.create(store);

    // Then
    expect(viewModel.show, isTrue);
  });

  test('should set show to FALSE if not ShowRatingState', () {
    // Given
    final store = givenState().dontShowRating().store();

    // When
    final viewModel = RatingViewModel.create(store);

    // Then
    expect(viewModel.show, isFalse);
  });

  test('should dispatch done action correctly', () {
    // Given
    final store = StoreSpy.withState(givenState().showRating());
    final viewModel = RatingViewModel.create(store);

    // When
    viewModel.onDone();

    // Then
    expect(store.dispatchedAction, isA<RatingDoneAction>());
  });
}
